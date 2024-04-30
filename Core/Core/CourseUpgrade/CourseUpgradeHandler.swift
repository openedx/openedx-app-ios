//
//  CourseUpgradeHandler.swift
//  Core
//
//  Created by Saeed Bashir on 4/23/24.
//

import Foundation

public enum CourseUpgradeScreen: String {
    case dashbaord
    case courseDashboard = "course_dashboard"
    case courseComponent = "course_component"
    case unknown
}

public class CourseUpgradeHandler: ObservableObject {
    
    static var ecommereceURL: String = ""
    
    public enum UpgradeState {
        case initial
        case basket
        case checkout
        case payment
        case verify
        case complete
        case error(type: UpgradeError, error: Error?)
    }

    public enum UpgradeMode: String {
        case silent
        case userInitiated = "user_initiated"
        case restore
    }
    
    public typealias UpgradeCompletionHandler = (UpgradeState) -> Void
    
    private var completion: UpgradeCompletionHandler?
    private(set) var course: CourseItem?
    private var basketID: Int = 0
    private var courseSku: String = ""
    private(set) var upgradeMode: UpgradeMode = .userInitiated
    private(set) var price: NSDecimalNumber?
    private(set) var currencyCode: String?
    private var interactor: CourseUpgradeInteractorProtocol
    private var storeKitHandler: StorekitHandler

    private(set) var state: UpgradeState = .initial {
        didSet {
            completion?(state)
        }
    }

    public init(config: ConfigProtocol,
                interactor: CourseUpgradeInteractorProtocol,
                storeKitHandler: StorekitHandler
    ) {
        self.interactor = interactor
        self.storeKitHandler = storeKitHandler
        
        CourseUpgradeHandler.ecommereceURL = config.ecommerceURL ?? ""
    }
    
    public func upgradeCourse(
        _ course: CourseItem,
        mode: UpgradeMode = .userInitiated,
        price: NSDecimalNumber?,
        currencyCode: String?,
        completion: UpgradeCompletionHandler?
    ) async {
        self.course = course
        self.completion = completion
        self.upgradeMode = mode
        self.price = price
        self.currencyCode = currencyCode
        
        guard let course = self.course, !course.sku.isEmpty else {
            state = .error(type: .generalError, error: error(message: "course sku is missing"))
            return
        }
        state = .initial
        courseSku = course.sku
        await proceedWithUpgrade()
    }
    
    @MainActor
    private func proceedWithUpgrade() async {
        do {
            let basket = try await interactor.addbasket(sku: courseSku)
            basketID = basket.basketID
            await checkout(basketID: basketID)
            
        } catch let error {
            if error.isInternetError {
                
            } else {
                state = .error(type: .basketError, error: error)
            }
        }
    }
    
    @MainActor
    private func checkout(basketID: Int) async {
        // Checkout API
        guard basketID > 0 else {
            state = .error(type: .checkoutError, error: error(message: "invalid basket id < zero"))
            return
        }
        
        state = .checkout
        do {
            _ = try await interactor.checkoutBasket(basketID: basketID)
            if upgradeMode != .userInitiated {
                reverifyPayment()
            } else {
                await makePayment()
            }
            
        } catch let error {
            if error.isInternetError {
                
            } else {
                state = .error(type: .checkoutError, error: error)
            }
        }
    }
    
    @MainActor
    private func makePayment() async {
        state = .payment
        storeKitHandler.purchaseProduct(courseSku) { [weak self] success, receipt, error in
            Task {
                if let receipt = receipt, success {
                    await self?.verifyPayment(receipt)
                } else {
                    self?.state = .error(type: (error?.type ?? .paymentError), error: error?.error)
                }
            }
        }
    }
    
    @MainActor
    private func verifyPayment(_ receipt: String) async {
        state = .verify
        
        do {
            try await interactor.fulfillCheckout(
                basketID: basketID,
                price: price ?? 0.0,
                currencyCode: currencyCode ?? "",
                receipt: receipt
            )
            state = .complete
            
        } catch let error {
            if error.isInternetError {
                
            } else {
                state = .error(type: .checkoutError, error: error)
            }
        }
    }
    
    // Give an option of retry to learner
    @MainActor
    func reverifyPayment() {
        storeKitHandler.purchaseReceipt { [weak self] (success, receipt, error) in
            if let receipt = receipt, success {
                Task {
                    await self?.verifyPayment(receipt)
                }
            } else {
                self?.state = .error(type: (error?.type ?? .receiptNotAvailable), error: error?.error)
            }
        }
    }
}

extension CourseUpgradeHandler {
    // IAP error messages
    var errorMessage: String {
        if case .error(let type, let error) = state {
            guard let error = error as NSError? else {
                return CoreLocalization.CourseUpgrade.FailureAlert.generalErrorMessage
            }
            switch type {
            case .basketError:
                return basketErrorMessage(for: error)
            case .checkoutError:
                return checkoutErrorMessage(for: error)
            case .paymentError:
                return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
            case .verifyReceiptError:
                return executeErrorMessage(for: error)
            default:
                return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
            }
        }
        return CoreLocalization.CourseUpgrade.FailureAlert.generalErrorMessage
    }

    private func basketErrorMessage(for error: NSError) -> String {
        switch error.code {
        case 400:
            return CoreLocalization.CourseUpgrade.FailureAlert.courseNotFount
        case 403:
            return CoreLocalization.CourseUpgrade.FailureAlert.authenticationErrorMessage
        case 406:
            return CoreLocalization.CourseUpgrade.FailureAlert.courseAlreadyPaid
        default:
            return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
        }
    }

    private func checkoutErrorMessage(for error: NSError) -> String {
        switch error.code {
        case 403:
            return CoreLocalization.CourseUpgrade.FailureAlert.authenticationErrorMessage
        default:
            return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
        }
    }

    private func executeErrorMessage(for error: NSError) -> String {
        switch error.code {
        case 409:
            return CoreLocalization.CourseUpgrade.FailureAlert.courseAlreadyPaid
        default:
            return CoreLocalization.CourseUpgrade.FailureAlert.courseNotFullfilled
        }
    }

    var formattedError: String {
        let unhandledError = "unhandledError"
        if case .error(let type, let error) = state {
            guard let error = error as NSError? else { return unhandledError }
            return "\(type.errorString)-\(error.code)-\(error.localizedDescription)"
        }
        
        return unhandledError
    }

    fileprivate func error(message: String) -> Error {
        return NSError(domain:"edx.app.courseupgrade", code: 1010, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

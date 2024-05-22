//
//  StorekitHandler.swift
//  Core
//
//  Created by Saeed Bashir on 4/23/24.
//

import Foundation
import SwiftyStoreKit
import StoreKit

// In case of completeTransctions SDK returns SwiftyStoreKit.Purchase
// And on the in-app purchase SDK returns SwiftyStoreKit.PurchaseDetails
public enum TransactionType: String {
    case transction
    case purchase
}

public enum UpgradeError: Error, LocalizedError {
    case paymentsNotAvailable // device isn't allowed to make payments
    case paymentError(Error?) // unable to purchase a product
    case receiptNotAvailable(Error?) // unable to fetech inapp purchase receipt
    case basketError(Error) // basket API returns error
    case checkoutError(Error) // checkout API returns error
    case verifyReceiptError(Error) // verify receipt API returns error
    case productNotExist // product not existed on app appstore
    case generalError(Error?) // general error
    
    var errorString: String {
        switch self {
        case .basketError:
            return "basket"
        case .checkoutError:
            return "checkout"
        case .paymentError:
            return "payment"
        case .verifyReceiptError:
            return "execute"
        default:
            return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .basketError(let error):
            return basketErrorMessage(for: error as NSError)
        case .checkoutError(let error):
            return checkoutErrorMessage(for: error as NSError)
        case .paymentError:
            return CoreLocalization.CourseUpgrade.FailureAlert.paymentNotProcessed
        case .verifyReceiptError(let error):
            return executeErrorMessage(for: error as NSError)
        default:
            break
        }
        return nil
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
    
    private var nestedError: Error? {
        switch self {
        case .receiptNotAvailable(let error):
            return error
        case .basketError(let error):
            return error
        case .checkoutError(let error):
            return error
        case .verifyReceiptError(let error):
            return error
        case .generalError(let error):
            return error
        case .paymentError(let error):
            return error
        default:
            return nil
        }
    }
    
    public var formattedError: String {
        let unhandledError = "unhandledError"
        guard let error = nestedError else { return unhandledError }
        return "\(errorString)-\((error as NSError).code)-\(error.localizedDescription)"
    }
    
    public var isCancelled: Bool {
        switch self {
        case .paymentError(let error):
            if let error = error as? SKError, error.code == .paymentCancelled {
                return true
            }
        default:
            break
        }
        return false
    }
}

public struct StoreProductInfo {
    var price: NSDecimalNumber
    var localizedPrice: String?
    var currencySymbol: String?
}

public protocol StoreInteractorProtocol {
    init(handler: StoreKitHandlerProtocol)
    
    func fetchProduct(sku: String) async throws -> StoreProductInfo
    func fetchProduct(sku: String, completion: @escaping (StoreProductInfo?, Error?) -> Void)
}

class StoreInteractorMock: StoreInteractorProtocol {
    required init(handler: StoreKitHandlerProtocol) {}
    
    func fetchProduct(sku: String) async throws -> StoreProductInfo {
        StoreProductInfo(price: .zero)
    }
    func fetchProduct(sku: String, completion: @escaping (StoreProductInfo?, (any Error)?) -> Void) {}
}

public struct StoreKitUpgradeResponse {
    var success: Bool
    var receipt: String?
    var error: UpgradeError?
}

public protocol StoreKitHandlerProtocol {
    typealias PurchaseCompletionHandler = (StoreKitUpgradeResponse) -> Void
    func fetchProduct(sku: String) async throws -> StoreProductInfo
    func fetchProduct(sku: String, completion: @escaping (StoreProductInfo?, Error?) -> Void)
    func completeTransactions()
    
    func purchaseProduct(_ identifier: String) async -> StoreKitUpgradeResponse
    func purchaseProduct(_ identifier: String, completion: PurchaseCompletionHandler?)
    
    func purchaseReceipt(completion: PurchaseCompletionHandler?)
    func purchaseReceipt() async -> StoreKitUpgradeResponse
}

class StoreKitHandlerMock: StoreKitHandlerProtocol {
    public func purchaseProduct(_ identifier: String) async -> StoreKitUpgradeResponse {
        StoreKitUpgradeResponse(success: false)
    }

    func purchaseProduct(_ identifier: String, completion: PurchaseCompletionHandler?) {}
    
    func fetchProduct(sku: String) async throws -> StoreProductInfo {
        StoreProductInfo(price: .zero)
    }
    func fetchProduct(sku: String, completion: @escaping (StoreProductInfo?, (any Error)?) -> Void) {}
    func completeTransactions() {}
    
    func purchaseReceipt() async -> StoreKitUpgradeResponse {
        StoreKitUpgradeResponse(success: false)
    }
    func purchaseReceipt(completion: PurchaseCompletionHandler?) {}
}

public class StoreInteractor: StoreInteractorProtocol {
    
    private let handler: StoreKitHandlerProtocol
    
    required public init(handler: StoreKitHandlerProtocol) {
        self.handler = handler
    }
    
    public func fetchProduct(sku: String) async throws -> StoreProductInfo {
        try await handler.fetchProduct(sku: sku)
    }
    
    public func fetchProduct(sku: String, completion: @escaping (StoreProductInfo?, (any Error)?) -> Void) {
        handler.fetchProduct(sku: sku, completion: completion)
    }
}

public class StorekitHandler: NSObject, StoreKitHandlerProtocol {
    
    // Use this dictionary to keep track of inprocess transctions and allow only one transction at a time
    private(set) var purchases: [String: Any] = [:]

    private var completion: PurchaseCompletionHandler?

    public var unfinishedPurchases: Bool {
        return !purchases.isEmpty
    }

    public var unfinishedProductIDs: [String] {
        return Array(purchases.keys)
    }
    
    public override init() {

    }
    
    public func completeTransactions() {
        // save and check if purchase is already there
        SwiftyStoreKit.completeTransactions(atomically: false) { [weak self] purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        // SwiftyStoreKit.finishTransaction(purchase.transaction)
                        self?.purchases[purchase.productId] =  purchase
                    }
                default:
                    break
                }
            }

            if !purchases.isEmpty {
                NotificationCenter.default.post(name: .unfullfilledTransctionsNotification, object: purchases)
            }
        }
    }
    
    public func purchaseProduct(_ identifier: String) async -> StoreKitUpgradeResponse {
        await withCheckedContinuation { continuation in
            purchaseProduct(identifier) { response in
                continuation.resume(returning: response)
            }
        }
    }

    public func purchaseProduct(_ identifier: String, completion: PurchaseCompletionHandler?) {
        guard SwiftyStoreKit.canMakePayments else {
            let response = StoreKitUpgradeResponse(success: false, receipt: nil, error: .paymentsNotAvailable)
            completion?(response)
            return
        }

        self.completion = completion

        SwiftyStoreKit.purchaseProduct(identifier, atomically: false) { [weak self] result in
            switch result {
            case .success(let purchase):
                self?.purchases[purchase.productId] = purchase
                self?.purchaseReceipt()
            case .error(let error):
                let response = StoreKitUpgradeResponse(success: false, receipt: nil, error: .paymentError(error))
                completion?(response)
                debugLog(error.localizedDescription)
            default:
                let response = StoreKitUpgradeResponse(success: false, receipt: nil, error: nil)
                completion?(response)
            }
        }
    }

    public func fetchProduct(sku: String) async throws -> StoreProductInfo {
        try await withCheckedThrowingContinuation { continuation in
            fetchPrroduct(sku) { product, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let product = product {
                    let dataProduct = StoreProductInfo(
                        price: product.price,
                        localizedPrice: product.localizedPrice,
                        currencySymbol: product.priceLocale.currencySymbol
                    )
                    continuation.resume(returning: dataProduct)
                }
            }
        }
    }
    
    public func fetchProduct(sku: String, completion: @escaping (StoreProductInfo?, Error?) -> Void) {
        fetchPrroduct(sku) { product, error in
            if let error = error {
                completion(nil, error)
            } else if let product = product {
                let dataProduct = StoreProductInfo(
                    price: product.price,
                    localizedPrice: product.localizedPrice,
                    currencySymbol: product.priceLocale.currencySymbol
                )
                completion(dataProduct, nil)
            }
        }
    }
    
    public func fetchPrroduct(_ identifier: String, completion: ((SKProduct?, UpgradeError?) -> Void)? = nil) {
        SwiftyStoreKit.retrieveProductsInfo([identifier]) { result in
            if let product = result.retrievedProducts.first {
                completion?(product, nil)
            } else if result.invalidProductIDs.count > 0 {
                completion?(nil, .productNotExist)
            } else {
                completion?(nil, .generalError(nil))
            }
        }
    }
    
    public func purchaseReceipt() async -> StoreKitUpgradeResponse {
        await withCheckedContinuation { continuation in
            purchaseReceipt { response in
                continuation.resume(returning: response)
            }
        }
    }
    
    public func purchaseReceipt(completion: PurchaseCompletionHandler? = nil) {
        if let completion = completion {
            self.completion = completion
        }
        
        SwiftyStoreKit.fetchReceipt(forceRefresh: false) { [weak self] result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                let response = StoreKitUpgradeResponse(success: true, receipt: encryptedReceipt)
                self?.completion?(response)
            case .error(let error):
                let response = StoreKitUpgradeResponse(success: true, receipt: nil, error: .receiptNotAvailable(error))
                self?.completion?(response)
            }
        }
    }

    public func markPurchaseComplete(_ productID: String, type: TransactionType) {
        // Mark the purchase complete
        switch type {
        case .transction:
            if let purchase = purchases[productID] as? Purchase {
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
        case .purchase:
            if let purchase = purchases[productID] as? PurchaseDetails {
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
        }

        removePurchase(productID)
    }

    public func removePurchase(_ productID: String) {
        purchases.removeValue(forKey: productID)
    }
}

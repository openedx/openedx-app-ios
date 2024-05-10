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
public enum TransctionType: String {
    case transction
    case purchase
}

public enum UpgradeError: Error {
    case paymentsNotAvailable // device isn't allowed to make payments
    case paymentError // unable to purchase a product
    case receiptNotAvailable // unable to fetech inapp purchase receipt
    case basketError // basket API returns error
    case checkoutError // checkout API returns error
    case verifyReceiptError // verify receipt API returns error
    case productNotExist // product not existed on app appstore
    case generalError // general error
    
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
            return ""
        }
    }
}

public struct StoreProduct {
    var price: NSDecimalNumber
    var localizedPrice: String?
    var currencySymbol: String?
}

public protocol StoreInteractorProtocol {
    init(handler: StoreKitHandlerProtocol)
    
    func fetchProduct(sku: String) async throws -> StoreProduct
    func fetchProduct(sku: String, completion: @escaping (StoreProduct?, Error?) -> Void)
}

class StoreInteractorMock: StoreInteractorProtocol {
    required init(handler: StoreKitHandlerProtocol) {}
    
    func fetchProduct(sku: String) async throws -> StoreProduct {
        StoreProduct(price: .zero)
    }
    func fetchProduct(sku: String, completion: @escaping (StoreProduct?, (any Error)?) -> Void) {}
}

public protocol StoreKitHandlerProtocol {
    typealias PurchaseCompletionHandler = ((success: Bool,
                                                   receipt: String?,
                                                   error: (type: UpgradeError?,
                                                           error: Error?)?)) -> Void
    func fetchProduct(sku: String) async throws -> StoreProduct
    func fetchProduct(sku: String, completion: @escaping (StoreProduct?, Error?) -> Void)
    func completeTransactions()
    
    func purchaseProduct(_ identifier: String, completion: PurchaseCompletionHandler?)
    func purchaseReceipt(completion: PurchaseCompletionHandler?)
}

class StoreKitHandlerMock: StoreKitHandlerProtocol {
    func purchaseReceipt(completion: PurchaseCompletionHandler?) {}
    
    func purchaseProduct(_ identifier: String, completion: PurchaseCompletionHandler?) {}
    
    func fetchProduct(sku: String) async throws -> StoreProduct {
        StoreProduct(price: .zero)
    }
    func fetchProduct(sku: String, completion: @escaping (StoreProduct?, (any Error)?) -> Void) {}
    func completeTransactions() {}
}

public class StoreInteractor: StoreInteractorProtocol {
    
    private let handler: StoreKitHandlerProtocol
    
    required public init(handler: StoreKitHandlerProtocol) {
        self.handler = handler
    }
    
    public func fetchProduct(sku: String) async throws -> StoreProduct {
        try await handler.fetchProduct(sku: sku)
    }
    
    public func fetchProduct(sku: String, completion: @escaping (StoreProduct?, (any Error)?) -> Void) {
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

    public func purchaseProduct(_ identifier: String, completion: PurchaseCompletionHandler?) {
        guard SwiftyStoreKit.canMakePayments else {
            completion?((false, receipt: nil, error: (type: .paymentsNotAvailable, error: nil)))
            return
        }

        self.completion = completion

        SwiftyStoreKit.purchaseProduct(identifier, atomically: false) { [weak self] result in
            switch result {
            case .success(let purchase):
                self?.purchases[purchase.productId] = purchase
                self?.purchaseReceipt()
            case .error(let error):
                completion?((false, receipt: nil, error: (type: .paymentError, error: error)))
                debugLog(((error as NSError).localizedDescription))
            default:
                completion?((false, receipt: nil, error: nil))
            }
        }
    }

    public func fetchProduct(sku: String) async throws -> StoreProduct {
        try await withCheckedThrowingContinuation { continuation in
            fetchPrroduct(sku) { product, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let product = product {
                    let dataProduct = StoreProduct(
                        price: product.price,
                        localizedPrice: product.localizedPrice,
                        currencySymbol: product.priceLocale.currencySymbol
                    )
                    continuation.resume(returning: dataProduct)
                }
            }
        }
    }
    
    public func fetchProduct(sku: String, completion: @escaping (StoreProduct?, Error?) -> Void) {
        fetchPrroduct(sku) { product, error in
            if let error = error {
                completion(nil, error)
            } else if let product = product {
                let dataProduct = StoreProduct(
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
                completion?(nil, .generalError)
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
                self?.completion?((true, receipt: encryptedReceipt, error: nil))
            case .error(let error):
                self?.completion?((false, receipt: nil, error: (type: .receiptNotAvailable, error: error)))
            }
        }
    }

    public func markPurchaseComplete(_ productID: String, type: TransctionType) {
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

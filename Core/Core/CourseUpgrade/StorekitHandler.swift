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

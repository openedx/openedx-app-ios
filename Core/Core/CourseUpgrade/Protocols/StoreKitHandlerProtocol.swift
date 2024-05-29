//
//  StoreKitHandlerProtocol.swift
//  Core
//
//  Created by Vadim Kuznetsov on 22.05.24.
//

import Foundation

//sourcery: AutoMockable
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

//
//  CourseUpgradeInteractor.swift
//  Core
//
//  Created by Saeed Bashir on 4/23/24.
//

import Foundation

//sourcery: AutoMockable
public protocol CourseUpgradeInteractorProtocol {
    func addbasket(sku: String) async throws -> UpgradeBasket
    func checkoutBasket(basketID: Int) async throws -> CheckoutBasket
    @discardableResult
    func fulfillCheckout(
        basketID: Int,
        price: NSDecimalNumber,
        currencyCode: String,
        receipt: String
    ) async throws -> FulfillCheckout
}

public class CourseUpgradeInteractor: CourseUpgradeInteractorProtocol {
    
    private let repository: CourseUpgradeRepositoryProtocol
    
    public init(repository: CourseUpgradeRepositoryProtocol) {
        self.repository = repository
    }
    
    public func addbasket(sku: String) async throws -> UpgradeBasket {
        return try await repository.addbasket(sku: sku)
    }
    
    public func checkoutBasket(basketID: Int) async throws -> CheckoutBasket {
        return try await repository.checkoutBasket(basketID: basketID)
    }
    
    @discardableResult
    public func fulfillCheckout(
        basketID: Int,
        price: NSDecimalNumber,
        currencyCode: String,
        receipt: String
    ) async throws -> FulfillCheckout {
        return try await repository.fulfillCheckout(
            basketID: basketID,
            price: price,
            currencyCode: currencyCode,
            receipt: receipt
        )
    }
}

public struct UpgradeBasket {
    let success: String
    let basketID: Int
}

public struct CheckoutBasket {
    let paymentPageURL: String
}

public struct FulfillCheckout {
    let orderData: DataLayer.OrderData
}

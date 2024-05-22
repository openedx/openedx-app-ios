//
//  CourseUpgradeInteractorProtocol.swift
//  Core
//
//  Created by Vadim Kuznetsov on 22.05.24.
//

import Foundation

//sourcery: AutoMockable
public protocol CourseUpgradeInteractorProtocol {
    func addBasket(sku: String) async throws -> UpgradeBasket
    func checkoutBasket(basketID: Int) async throws -> CheckoutBasket
    @discardableResult
    func fulfillCheckout(
        basketID: Int,
        price: NSDecimalNumber,
        currencyCode: String,
        receipt: String
    ) async throws -> FulfillCheckout
}

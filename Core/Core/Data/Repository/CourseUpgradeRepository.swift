//
//  CourseUpgradeRepository.swift
//  Core
//
//  Created by Saeed Bashir on 4/23/24.
//

import Foundation

public protocol CourseUpgradeRepositoryProtocol {
    func addbasket(sku: String) async throws -> UpgradeBasket
    func checkoutBasket(basketID: Int) async throws -> CheckoutBasket
    func fulfillCheckout(
        basketID: String,
        price: NSDecimalNumber,
        currencyCode: String,
        receipt: String
    ) async throws -> FulfillCheckout
}

public class CourseUpgradeRepository: CourseUpgradeRepositoryProtocol {
    private let api: API
    private let config: ConfigProtocol
    
    public init(api: API, config: ConfigProtocol) {
        self.api = api
        self.config = config
    }
    
    public func addbasket(sku: String) async throws -> UpgradeBasket {
        let result = try await api.requestData(
            CourseUpgradeEndpoint.addBasket(sku: sku)
        ).mapResponse(DataLayer.UpgradeBasket.self)
        
        return result.domain
    }
    
    public func checkoutBasket(basketID: Int) async throws -> CheckoutBasket {
        let result = try await api.requestData(
            CourseUpgradeEndpoint.checkout(basketID: basketID)
        ).mapResponse(DataLayer.CheckoutBasket.self)
        
        return result.domain
    }
    
    public func fulfillCheckout(
        basketID: String,
        price: NSDecimalNumber,
        currencyCode: String,
        receipt: String
    ) async throws -> FulfillCheckout {
        let result = try await api.requestData(
            CourseUpgradeEndpoint.fulfillCheckout(
                basketID: basketID,
                price: price,
                currencyCode: currencyCode,
                receipt: receipt
            )
        ).mapResponse(DataLayer.FulfillCheckout.self)
        
        return result.domain
    }
}

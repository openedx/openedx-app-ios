//
//  CourseUpgradeEndpoint.swift
//  Core
//
//  Created by Saeed Bashir on 4/23/24.
//

import Foundation
import Alamofire

private let PaymentProcessor = "ios-iap"

enum CourseUpgradeEndpoint: EndPointType {
    case addBasket(sku: String)
    case checkout(basketID: Int)
    case fulfillCheckout(
        basketID: Int,
        price: NSDecimalNumber,
        currencyCode: String,
        receipt: String
    )
    
    var path: String {
        switch self {
        case let .addBasket(sku):
            return "/api/iap/v1/basket/add/?sku=\(sku)"
        case .checkout:
            return "/api/iap/v1/checkout/"
        case .fulfillCheckout:
            return "/api/iap/v1/execute/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .addBasket:
            return .get
        case .checkout:
            return .post
        case .fulfillCheckout:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var baseURL: String {
        return CourseUpgradeHandler.ecommereceURL
    }
    
    var task: HTTPTask {
        switch self {
        case .addBasket:
            return .request
        case let .checkout(basketID):
            let params: Parameters = [
                "basket_id": basketID,
                "payment_processor": PaymentProcessor
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.httpBody)
            
        case let .fulfillCheckout(
            basketID: basketID,
            price: price,
            currencyCode: currencyCode,
            receipt: receipt):
            
            let params: Parameters = [
                "basket_id": basketID,
                "price": price,
                "currency_code": currencyCode,
                "purchase_token": receipt,
                "payment_processor": PaymentProcessor
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.httpBody)
        }
    }
}

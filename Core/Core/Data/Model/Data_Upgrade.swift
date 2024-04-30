//
//  Data_Upgrade.swift
//  Core
//
//  Created by Saeed Bashir on 4/23/24.
//

import Foundation

public extension DataLayer {
    struct UpgradeBasket: Codable {
        public let success: String
        public let basketID: Int
        
        enum CodingKeys: String, CodingKey {
            case success
            case basketID = "basket_id"
        }
    }

    struct CheckoutBasket: Codable {
        let paymentPageURL: String
        
        enum CodingKeys: String, CodingKey {
            case paymentPageURL = "payment_page_url"
        }
    }

    struct FulfillCheckout: Codable {
        let status: String
    }
}

public extension DataLayer.UpgradeBasket {
    var domain: UpgradeBasket {
        UpgradeBasket(success: success, basketID: basketID)
    }
}

public extension DataLayer.CheckoutBasket {
    var domain: CheckoutBasket {
        CheckoutBasket(paymentPageURL: paymentPageURL)
    }
}

public extension DataLayer.FulfillCheckout {
    var domain: FulfillCheckout {
        FulfillCheckout(status: status)
    }
}

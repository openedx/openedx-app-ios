//
//  StoreKitUpgradeResponse.swift
//  Core
//
//  Created by Vadim Kuznetsov on 22.05.24.
//

import Foundation

public struct StoreKitUpgradeResponse {
    var success: Bool
    var receipt: String?
    var error: UpgradeError?
}

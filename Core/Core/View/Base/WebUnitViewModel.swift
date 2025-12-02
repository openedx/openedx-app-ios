//
//  WebUnitViewModel.swift
//  Core
//
//  Created by  Stepanok Ivan on 17.10.2022.
//

import Foundation
import SwiftUI

@Observable
public final class WebUnitViewModel: WebviewCookiesUpdateProtocol {
    
    public let authInteractor: AuthInteractorProtocol
    let config: ConfigProtocol
    let syncManager: OfflineSyncManagerProtocol
    
    public var updatingCookies: Bool = false
    public var cookiesReady: Bool = false
    public var showError: Bool = false
    private var retryCount = 1
    
    public var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    public init(
        authInteractor: AuthInteractorProtocol,
        config: ConfigProtocol,
        syncManager: OfflineSyncManagerProtocol
    ) {
        self.authInteractor = authInteractor
        self.config = config
        self.syncManager = syncManager
    }
}

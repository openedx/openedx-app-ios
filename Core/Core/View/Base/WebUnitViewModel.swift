//
//  WebUnitViewModel.swift
//  Core
//
//  Created by  Stepanok Ivan on 17.10.2022.
//

import Foundation
import SwiftUI

public final class WebUnitViewModel: ObservableObject, WebviewCookiesUpdateProtocol {
    
    public let authInteractor: AuthInteractorProtocol
    let config: ConfigProtocol
    let syncManager: OfflineSyncManagerProtocol
    
    @Published public var updatingCookies: Bool = false
    @Published public var cookiesReady: Bool = false
    @Published public var showError: Bool = false
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

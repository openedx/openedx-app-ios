//
//  UserProfileViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 10.10.2023.
//

import Core
import SwiftUI

public class UserProfileViewModel: ObservableObject {
    
    @Published public var userModel: UserProfile?
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    private let username: String
        
    private let interactor: ProfileInteractorProtocol
    
    public init(
        interactor: ProfileInteractorProtocol,
        username: String
    ) {
        self.interactor = interactor
        self.username = username
    }
    
    @MainActor
    func getUserProfile(withProgress: Bool = true) async {
        isShowProgress = withProgress
        do {
            userModel = try await interactor.getUserProfile(username: username)
            isShowProgress = false
        } catch let error {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            
        }
    }
}

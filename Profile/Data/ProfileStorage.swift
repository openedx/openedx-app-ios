//
//  ProfileStorage.swift
//  Profile
//
//  Created by  Stepanok Ivan on 30.08.2023.
//

import Foundation
import Core

public protocol ProfileStorage {
    var userProfile: DataLayer.UserProfile? { get set }
}

#if DEBUG
public class ProfileStorageMock: ProfileStorage {
  
    public var userProfile: DataLayer.UserProfile?
    
    public init() {}
}
#endif

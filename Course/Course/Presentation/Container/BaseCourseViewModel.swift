//
//  BaseCourseViewModel.swift
//  Course
//
//  Created by Vladimir Chekyrta on 14.03.2023.
//

import Foundation
import SwiftUI
import Core
import Combine

@MainActor
open class BaseCourseViewModel: ObservableObject {
    
    let manager: DownloadManagerProtocol
    var cancellables = Set<AnyCancellable>()

    init(manager: DownloadManagerProtocol) {
        self.manager = manager
    }
}

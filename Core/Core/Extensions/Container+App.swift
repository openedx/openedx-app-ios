//
//  Container+App.swift
//  Core
//
//  Created by  Stepanok Ivan on 13.10.2022.
//

import Foundation
import Swinject

public extension Container {
    static var shared: Container = {
        let container = Container()
        return container
    }()
}

public extension UIViewController {
    var diContainer: Container {
        return Container.shared
    }
}

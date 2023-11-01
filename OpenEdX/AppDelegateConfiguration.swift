//
//  AppDelegateConfiguration.swift
//  OpenEdX
//
//  Created by Eugene Yatsenko on 01.11.2023.
//

import Core
import Swinject
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics

public class AppDelegateConfiguration: AppDelegateConfigurable {

    public var assembler: Assembler?

    public init() {
        initDI()
    }

    public func didFinishLaunching() {
        guard let configuration = Container.shared.resolve(Configurable.self) else {
            return
        }

        if let firebaseOptions = configuration.firebaseOptions,
            configuration.firebaseOptions?.apiKey != "" {
            FirebaseApp.configure(options: firebaseOptions)
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        }
    }

    private func initDI() {
        let navigation = UINavigationController()
        navigation.modalPresentationStyle = .fullScreen

        assembler = Assembler(
            [
                AppAssembly(navigation: navigation),
                NetworkAssembly(),
                ScreenAssembly()
            ],
            container: Container.shared
        )
    }
}

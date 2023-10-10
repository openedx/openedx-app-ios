//
//  AppDelegate.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import Core
import Swinject
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
import Profile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
        
    private var assembler: Assembler?
    
    private var lastForceLogoutTime: TimeInterval = 0
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        if BuildConfiguration.shared.firebaseOptions.apiKey != "" {
            FirebaseApp.configure(options: BuildConfiguration.shared.firebaseOptions)
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        }
        
        initDI()
        
        Theme.Fonts.registerFonts()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RouteController()
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(forceLogoutUser),
            name: .onTokenRefreshFailed,
            object: nil
        )
        
        return true
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
    
    @objc private func forceLogoutUser() {
        guard Date().timeIntervalSince1970 - lastForceLogoutTime > 5 else {
            return
        }
        let analytics = Container.shared.resolve(AnalyticsManager.self)
        analytics?.userLogout(force: true)
        
        lastForceLogoutTime = Date().timeIntervalSince1970
        
        Container.shared.resolve(CoreStorage.self)?.clear()
        Container.shared.resolve(DownloadManagerProtocol.self)?.deleteAllFiles()
        Container.shared.resolve(CoreDataHandlerProtocol.self)?.clear()
        window?.rootViewController = RouteController()
    }
    
}

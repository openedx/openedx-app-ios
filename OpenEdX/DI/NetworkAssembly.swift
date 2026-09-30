//
//  NetworkAssembly.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Foundation
import Core
import OEXFoundation
import Alamofire
import Swinject

class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(InstanceStore.self) { _ in
            InstanceStore()
        }.inObjectScope(.container)

        container.register(InstanceProvider.self) { r in
            r.resolve(InstanceStore.self)!
        }.inObjectScope(.container)

        container.register(InstanceFilePathProvider.self) { r in
            InstanceFilePathProvider(instanceStore: r.resolve(InstanceProvider.self)!)
        }.inObjectScope(.container)

        container.register(InstanceApiServiceProtocol.self) { _ in
            // INSTANCES_CATALOG_URL now lives in the bundled config.json's app-level
            // keys (see InstanceConfigLoader.bundledCatalogURL()), not ConfigProtocol --
            // that property is dead weight, left in place only until the ConfigProtocol
            // cleanup pass that retires YAML for the app-level keys still on Config too.
            InstanceApiService(url: InstanceConfigLoader.bundledCatalogURL())
        }.inObjectScope(.container)

        container.register(InstanceConfigLoader.self) { r in
            InstanceConfigLoader(apiService: r.resolve(InstanceApiServiceProtocol.self)!)
        }.inObjectScope(.container)

        container.register(RequestInterceptor.self) { r in
            RequestInterceptor(
                config: r.resolve(ConfigProtocol.self)!,
                storage: r.resolve(CoreStorage.self)!,
                instanceStore: r.resolve(InstanceProvider.self)!
            )
        }.inObjectScope(.container)
        
        container.register(Alamofire.Session.self) { r in
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 60
            configuration.timeoutIntervalForResource = 60
            
            let interceptor = r.resolve(RequestInterceptor.self)!
            
            var eventMonitors: [EventMonitor] = []
            #if DEBUG
            let logger = NetworkLogger()
            eventMonitors.append(logger)
            #endif
            
            return Alamofire.Session(
                configuration: configuration,
                interceptor: interceptor,
                redirectHandler: HeadersRedirectHandler(),
                eventMonitors: eventMonitors
            )
        }.inObjectScope(.container)
        
        container.register(API.self) {r in
            API(session: r.resolve(Alamofire.Session.self)!, baseURL: r.resolve(ConfigProtocol.self)!.baseURL)
        }.inObjectScope(.container)
    }
}

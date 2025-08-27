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
        container.register(RequestInterceptor.self) { r in
            RequestInterceptor(config: r.resolve(ConfigProtocol.self)!, storage: r.resolve(CoreStorage.self)!)
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
        
        container.register(API.self) { r in
            let tenantProviderResolver = { r.resolve(TenantProvider.self)! }
            return API(session: r.resolve(Alamofire.Session.self)!, baseURL: tenantProviderResolver.baseURL,
                config: r.resolve(ConfigProtocol.self)!,
                tenantProvider: tenantProviderResolver)
        }.inObjectScope(.container)
    }
}

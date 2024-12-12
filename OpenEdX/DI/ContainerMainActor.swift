//
//  Container.MainActor
//  OpenEdX
//
//  Created by Ivan Stepanok on 14.11.2024.
//

import Foundation
@preconcurrency import Swinject

//swiftlint:disable line_length
// MARK: - MainActor registration
@available(iOS 13.0, macOS 10.15, *)
extension Container {

    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a ``Resolver`` to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { r in
            MainActor.assumeIsolated {
                return mainActorFactory(r)
            }
        }
    }
}

// MARK: - MainActor registration with Arguments
@available(iOS 13.0, macOS 10.15, *)
extension Container {
    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a `Resolver` instance and 1 argument to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable, Arg1: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver, Arg1) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { (resolver: Resolver, arg1: Arg1) in
            MainActor.assumeIsolated {
                return mainActorFactory(resolver, arg1)
            }
        }
    }

    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a `Resolver` instance and 2 arguments to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver, Arg1, Arg2) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { (resolver: Resolver, arg1: Arg1, arg2: Arg2) in
            MainActor.assumeIsolated {
                return mainActorFactory(resolver, arg1, arg2)
            }
        }
    }

    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a `Resolver` instance and 3 arguments to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver, Arg1, Arg2, Arg3) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { (resolver: Resolver, arg1: Arg1, arg2: Arg2, arg3: Arg3) in
            MainActor.assumeIsolated {
                return mainActorFactory(resolver, arg1, arg2, arg3)
            }
        }
    }

    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a `Resolver` instance and 4 arguments to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable, Arg4: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver, Arg1, Arg2, Arg3, Arg4) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { (resolver: Resolver, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) in
            MainActor.assumeIsolated {
                return mainActorFactory(resolver, arg1, arg2, arg3, arg4)
            }
        }
    }

    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a `Resolver` instance and 5 arguments to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable, Arg4: Sendable, Arg5: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { (resolver: Resolver, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) in
            MainActor.assumeIsolated {
                return mainActorFactory(resolver, arg1, arg2, arg3, arg4, arg5)
            }
        }
    }

    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a `Resolver` instance and 6 arguments to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable, Arg4: Sendable, Arg5: Sendable, Arg6: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { (resolver: Resolver, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) in
            MainActor.assumeIsolated {
                return mainActorFactory(resolver, arg1, arg2, arg3, arg4, arg5, arg6)
            }
        }
    }

    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a `Resolver` instance and 7 arguments to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable, Arg4: Sendable, Arg5: Sendable, Arg6: Sendable, Arg7: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { (resolver: Resolver, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) in
            MainActor.assumeIsolated {
                return mainActorFactory(resolver, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
            }
        }
    }

    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a `Resolver` instance and 8 arguments to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable, Arg4: Sendable, Arg5: Sendable, Arg6: Sendable, Arg7: Sendable, Arg8: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { (resolver: Resolver, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) in
            MainActor.assumeIsolated {
                return mainActorFactory(resolver, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
            }
        }
    }

    /// Adds a registration for the specified service with the factory closure to specify how the service is
    /// resolved with dependencies which must be resolved on the main actor.
    ///
    /// - Parameters:
    ///   - serviceType:        The service type to register.
    ///   - name:               A registration name, which is used to differentiate from other registrations
    ///                         that have the same service and factory types.
    ///   - mainActorFactory:   The @MainActor closure to specify how the service type is resolved with the dependencies of the type.
    ///                         It is invoked when the ``Container`` needs to instantiate the instance.
    ///                         It takes a `Resolver` instance and 9 arguments to inject dependencies to the instance,
    ///                         and returns the instance of the component type for the service.
    ///
    /// - Returns: A registered ``ServiceEntry`` to configure more settings with method chaining.
    @discardableResult
    public func register<Service: Sendable, Arg1: Sendable, Arg2: Sendable, Arg3: Sendable, Arg4: Sendable, Arg5: Sendable, Arg6: Sendable, Arg7: Sendable, Arg8: Sendable, Arg9: Sendable>(
        _ serviceType: Service.Type,
        name: String? = nil,
        mainActorFactory: @escaping @MainActor (Resolver, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9) -> Service
    ) -> ServiceEntry<Service> {
        return register(serviceType, name: name) { (resolver: Resolver, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) in
            MainActor.assumeIsolated {
                return mainActorFactory(resolver, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
            }
        }
    }
}
//swiftlint:enable line_length

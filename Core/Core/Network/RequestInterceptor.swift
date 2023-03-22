//
//  RequestInterceptor.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Alamofire

final public class RequestInterceptor: Alamofire.RequestInterceptor {
    
    private let config: Config
    private let appStorage: AppStorage
    
    public init(config: Config, appStorage: AppStorage) {
        self.config = config
        self.appStorage = appStorage
    }
    
    private let lock = NSLock()
    
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void) {
            //            guard urlRequest.url?.absoluteString.hasPrefix("https://api.authenticated.com") == true else {
            //                /// If the request does not require authentication, we can directly return it as unmodified.
            //                return completion(.success(urlRequest))
            //            }
            var urlRequest = urlRequest
            
            // Set the Authorization header value using the access token.
            if let token = appStorage.accessToken {
                urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            }
            
            completion(.success(urlRequest))
        }
    
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void) {
            lock.lock(); defer { lock.unlock() }
            
            guard let response = request.task?.response as? HTTPURLResponse,
                    response.statusCode == 401,
                  !response.url!.absoluteString.hasSuffix("deactivate_logout/") else {
                // The request did not fail due to a 401 Unauthorized response.
                // Return the original error and don't retry the request.
//                return completion(.doNotRetryWithError(error))
                return completion(.doNotRetry)
            }
            
            guard let token = appStorage.refreshToken else {
                return completion(.doNotRetryWithError(error))
            }
            
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshToken(refreshToken: token) { [weak self] succeeded in
                    guard let self = self else { return }
                    
                    self.lock.lock(); defer { self.lock.unlock() }
                    
                    if succeeded {
                        //Retry all requests
                        self.requestsToRetry.forEach { request in
                            request(.retry)
                        }
                        self.requestsToRetry.removeAll()
                    } else {
                        NotificationCenter.default.post(name: .onTokenRefreshFailed, object: nil)
                    }
                }
            }
        }
    
    private func refreshToken(
        refreshToken: String,
        completion: @escaping (_ succeeded: Bool) -> Void) {
            guard !isRefreshing else { return }
            
            isRefreshing = true
            
            let url = config.baseURL.appendingPathComponent("/oauth2/access_token")
            
            let parameters = [
                "grant_type": Constants.GrantTypeRefreshToken,
                "client_id": config.oAuthClientId,
                "refresh_token": refreshToken
            ]
            AF.request(
                url,
                method: .post,
                parameters: parameters,
                encoding: URLEncoding.httpBody
            ).response { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case let .success(data):
                    do {
                        let json = try JSONSerialization.jsonObject(
                            with: data!,
                            options: .mutableContainers
                        ) as? [String: AnyObject]
                        guard let json,
                              let accessToken = json["access_token"] as? String,
                              let refreshToken = json["refresh_token"] as? String,
                              accessToken.count > 0,
                              refreshToken.count > 0 else {
                            return completion(false)
                        }
                        self.appStorage.accessToken = accessToken
                        self.appStorage.refreshToken = refreshToken
                        completion(true)
                    } catch {
                        completion(false)
                    }
                case .failure:
                    completion(false)
                }
                self.isRefreshing = false
            }
        }
}

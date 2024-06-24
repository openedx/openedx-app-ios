//
//  RequestInterceptor.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Alamofire

final public class RequestInterceptor: Alamofire.RequestInterceptor {
    
    private let config: ConfigProtocol
    private var storage: CoreStorage
    
    public init(config: ConfigProtocol, storage: CoreStorage) {
        self.config = config
        self.storage = storage
    }
    
    private let lock = NSLock()
    
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void) {
//            guard urlRequest.url?.absoluteString.hasPrefix("https://api.authenticated.com") == true else {
//                // If the request does not require authentication, we can directly return it as unmodified.
//                return completion(.success(urlRequest))
//            }
            var urlRequest = urlRequest
            
            // Set the Authorization header value using the access token.
            if let token = storage.accessToken {
                urlRequest.setValue("\(config.tokenType.rawValue) \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let userAgent: String = {
                if let info = Bundle.main.infoDictionary {
                    let executable: AnyObject = info[kCFBundleExecutableKey as String] as AnyObject? ?? "Unknown" as AnyObject
                    let bundle: AnyObject = info[kCFBundleIdentifierKey as String] as AnyObject? ?? "Unknown" as AnyObject
                    let version: AnyObject = info["CFBundleShortVersionString"] as AnyObject? ?? "Unknown" as AnyObject
                    let os: AnyObject = ProcessInfo.processInfo.operatingSystemVersionString as AnyObject
                    var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
                    let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
                    if CFStringTransform(mutableUserAgent, nil, transform, false) == true {
                        return mutableUserAgent as String
                    }
                }
                return "Alamofire"
            }()
            
            urlRequest.setValue(userAgent, forHTTPHeaderField: "User-Agent")
            
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
            
            guard let token = storage.refreshToken else {
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
                        NotificationCenter.default.post(
                            name: .userLoggedOut,
                            object: nil,
                            userInfo: [Notification.UserInfoKey.isForced: true]
                        )
                    }
                }
            }
        }
    
    private func refreshToken(
        refreshToken: String,
        completion: @escaping (_ succeeded: Bool) -> Void
    ) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        let url = config.baseURL.appendingPathComponent("/oauth2/access_token")
        
        let parameters: [String: Encodable] = [
            "grant_type": Constants.GrantTypeRefreshToken,
            "client_id": config.oAuthClientId,
            "refresh_token": refreshToken,
            "token_type": config.tokenType.rawValue,
            "asymmetric_jwt": true
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
                    self.storage.accessToken = accessToken
                    self.storage.refreshToken = refreshToken
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

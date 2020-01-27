//
//  Router.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

struct Router<T: Codable> {
    
    enum ServerType: String {
        case debug = "http://13.125.28.123/api"
        case live = "https://api.tingting.kr/api"
    }
    
    enum ServerVersion: String {
        case v1 = "/v1"
        case v2 = "/v2"
    }
    
    private let server: ServerType = .debug
    private let version: ServerVersion = .v1
    
    private var baseURL: String {
        server.rawValue + version.rawValue
    }
    private let removeTokenCodes: [Int]
    private let url: String
    private let parameters: [String : Any]?
    private let method: HTTPMethod
    private var headers: HTTPHeaders = .init()
    private let mockData: T?
    
    init(url: String,
         method: HTTPMethod = .get,
         parameters: Encodable? = nil,
         removeTokenCodes: [Int] = [],
         mockData: T? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters?.dictionary
        self.removeTokenCodes = removeTokenCodes
        self.mockData = mockData
        
        
        let header = "┌─────────[ Request ]─────────┐"
        let footer = "└─────────────────────────────┘"
        
        var requestLogger: [String] = ["", header, ""]
        if let token = ConnectionManager.shared.loadToken() {
            headers.add(name: "Authorization", value: token)
            requestLogger.append(token)
        }
        
        requestLogger += ["", baseURL + url, method.rawValue]
        if let prettyString = parameters?.prettyString {
            requestLogger += ["", prettyString]
        }

        requestLogger += ["", footer]
        Logger.info(requestLogger.joined(separator: "\n"))
        
        
    }
  
    var dataRequest: DataRequest {
        let encoding: URLEncoding
        switch method {
        case .get:
            encoding = .default
        default:
            encoding = .httpBody
        }
        return AF.request(baseURL + url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}

extension Router {
    func asObservable() -> Observable<T> {
        
        
        let header = "┌────────[ Response ]─────────┐"
        let footer = "└─────────────────────────────┘"
        
        var responseLogger: [String] = ["", header, ""]
        
        if let mockData = mockData {
            responseLogger += ["", "🔴 Mock Data 🔴"]
            return Observable.just(mockData)
        }
        
        return Observable<T>.create { observer in
            
            
            let session = self.dataRequest.responseData { result in
                 
                defer {
                    responseLogger += ["", footer]
                    Logger.info(responseLogger.joined(separator: "\n"))
                }
                
                if let statusCode = result.response?.statusCode,
                    self.removeTokenCodes.firstIndex(of: statusCode) != nil {
                    ConnectionManager.shared.removeToken()
                }
                
                if let error = result.error {
                    responseLogger += ["🔴 ERROR 🔴", "\(error)"]
                    observer.onError(error)
                    return
                }

                guard let data = result.data else {
                    responseLogger += ["🔴🔴 ERROR 🔴🔴", "\(result)"]
                    return
                }
                
                do {
                    let responseModel = try JSONDecoder().decode(ResponseModel<T>.self, from: data)
                    
                    guard let response = responseModel.data else {
                        let error = StringError(message: responseModel.errorMessage ?? "Undefine error")

                        responseLogger += ["🔴 ERROR 🔴", responseModel.prettyString ?? ""]
                        observer.onError(error)
                        return
                    }
                    
                    responseLogger += ["", response.prettyString ?? ""]
                    observer.onNext(response)
                    observer.onCompleted()
                    
                    
                } catch {

                    responseLogger += ["🔴 Catch ERROR 🔴"]
                    responseLogger += [result.data?.prettyPrintedJSONString as String? ?? ""]
                     responseLogger += ["\(error)"]
                    observer.onError(error)
                }
            }
            
            return Disposables.create { session.cancel() }
        }.single()
        
    }
}


fileprivate struct ResponseModel<T: Codable>: Codable {
    let data: T?
    let errorMessage: String?
}

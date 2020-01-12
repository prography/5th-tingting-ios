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
    
    private let server: ServerType = .live
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
        
        if let token = ConnectionManager.shared.loadToken() {
            Logger.info(token)
            headers.add(name: "Authorization", value: token)
        }
         
        Logger.info(["", baseURL + url, method.rawValue].joined(separator: "\n"))
        if let prettyString = parameters?.prettyString {
            Logger.info("\n\(prettyString)")
        }
        
        
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
        
        if let mockData = mockData {
            Logger.debug("\n🔴 Mock Data 🔴")
            return Observable.just(mockData)
        }
        
        return Observable<T>.create { observer in
            
            let session = self.dataRequest.responseData { result in
                
                if let statusCode = result.response?.statusCode,
                    self.removeTokenCodes.firstIndex(of: statusCode) != nil {
                    ConnectionManager.shared.removeToken()
                }
                
                if let error = result.error {
                    Logger.error(error)
                    observer.onError(error)
                    return
                }
                
                //                guard
                //                    let data = result.data,
                //                    let prettyString = data.prettyPrintedJSONString else
                //                {
                //                    Logger.error(RxError.noElements)
                //                    observer.onError(RxError.noElements)
                //                    return
                //                }
                //
                //                Logger.info("\n\(prettyString)")
                
                guard let data = result.data else {
                    Logger.error(result)
                    return
                }
                
                do {
                    let responseModel = try JSONDecoder().decode(ResponseModel<T>.self, from: data)
                    
                    guard let response = responseModel.data else {
                        let error = StringError(message: responseModel.errorMessage ?? "Undefine error")
                        Logger.error("\n\(responseModel.prettyString ?? "")")
                        observer.onError(error)
                        return
                    }
                    
                    Logger.info("\n\(response.prettyString ?? "")")
                    observer.onNext(response)
                    observer.onCompleted()
                    
                    
                } catch {
                    Logger.error(result.data?.prettyPrintedJSONString ?? "")
                    Logger.error(error)
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

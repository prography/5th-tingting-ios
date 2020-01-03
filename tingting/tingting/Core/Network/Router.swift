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
        case live = "http://tingting.kr/api"
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
    
    private let url: String
    private let parameters: [String : Any]?
    private let method: HTTPMethod
    private var header: HTTPHeaders?
    
    init(url: String, method: HTTPMethod = .get, parameters: Encodable? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters?.dictionary
        self.header = HTTPHeaders()
        header?.add(name: "Authorization", value: "InsertAuthKey")
    }
    
    var dataRequest: DataRequest {
        let encoding: URLEncoding
        switch method {
        case .get:
            encoding = .default
        default:
            encoding = .httpBody
        }
        return AF.request(baseURL + url, method: method, parameters: parameters, encoding: encoding, headers: header)
    }
}

extension Router {
    func asObservable() -> Observable<T> {
         Observable<T>.create{ observer in
            
            let session = self.dataRequest.responseData { result in
                
                if let error = result.error {
                    Logger.error(error)
                    observer.onError(error)
                    return
                }
                
                guard
                    let data = result.data,
                    let prettyString = data.prettyPrintedJSONString else
                {
                    Logger.error(RxError.noElements)
                    observer.onError(RxError.noElements)
                    return
                }
                
                Logger.info(prettyString)
                
                do {
                    let responseModel = try JSONDecoder().decode(ResponseModel<T>.self, from: data)
                    
                    guard let response = responseModel.data else {
                        let error = StringError(message: responseModel.errorMessage ?? "Undefine error")
                        observer.onError(error)
                        return
                    }
                    
                    observer.onNext(response)
                    observer.onCompleted()
                    
                    
                } catch {
                    Logger.error(error)
                    observer.onError(error)
                }
            }
            
            return Disposables.create { session.cancel() }
        }
        
    }
}


fileprivate struct ResponseModel<T: Codable>: Codable {
    let data: T?
    let errorMessage: String?
}

fileprivate struct StringError : LocalizedError {
    let message : String
}

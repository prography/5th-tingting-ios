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
        case debug = "https://dapi.kakao.com"
    }
    
    enum ServerVersion: String {
        case v1 = "/v1"
        case v2 = "/v2"
    }
    
    private let server: ServerType = .debug
    private let version: ServerVersion = .v2
    
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
        header?.add(name: "Authorization", value: "KakaoAK 915ece0fc273daa10c6d6103303d10e0")
    }
    
    var dataRequest: DataRequest {
        let encoding: URLEncoding
        switch method {
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = URLEncoding.httpBody
        }
        return AF.request(baseURL + url, method: method, parameters: parameters, encoding: encoding, headers: header)
    }
}

extension Router {
    func asObservable() -> Observable<T> {
         Observable<T>.create{ observer in
            
            let session = self.dataRequest.responseData { response in
                
                if let error = response.error {
                    Logger.error(error)
                    observer.onError(error)
                    return
                }
                
                do {
                    
                    if let data = response.data, let prettyString = data.prettyPrintedJSONString {
                        Logger.info(prettyString)
                        let value = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(value)
                        observer.onCompleted()
                    } else {
                        Logger.error(RxError.noElements)
                        observer.onError(RxError.noElements)
                    }
                } catch {
                    Logger.error(error)
                    observer.onError(error)
                }
            }
            
            return Disposables.create { session.cancel() }
        }
        
    }
}

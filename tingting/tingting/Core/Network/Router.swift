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
import RxAlamofire

enum ServerType: String {
    case debug = "http://13.209.81.52/api"
    case live = "http://api.tingting.kr/api"
}

enum ServerVersion: String {
    case v1 = "/v1"
    case v2 = "/v2"
}

var CURRENT_SERVER: ServerType = {
    return UserDefaults.standard.bool(forKey: "isDebug") ? .debug : .live
    }()
    {
    didSet {
        UserDefaults.standard.set(CURRENT_SERVER == .debug, forKey: "isDebug")
    }
}

let CURRENT_SERVER_VERSION: ServerVersion = .v1


struct Router<T: Codable> {
      
    private let server: ServerType = CURRENT_SERVER
    private let version: ServerVersion = CURRENT_SERVER_VERSION
    
    private var baseURL: String {
        server.rawValue + version.rawValue
    }
    private var headers: HTTPHeaders = .init()
    
    private let url: String
    private let parameters: [String : Any]?
    private let imageDict: [String: UIImage]
    private let method: HTTPMethod
    private let removeTokenCodes: [Int]
    private let mockData: T?


    var requestString: String = ""

    init(url: String,
         method: HTTPMethod = .get,
         parameters: Encodable? = nil,
         imageDict: [String: UIImage] = [:],
         removeTokenCodes: [Int] = [],
         mockData: T? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters?.dictionary
        self.imageDict = imageDict
        self.removeTokenCodes = removeTokenCodes
        self.mockData = mockData

        var requestLogger: [String] = [""]
        if let token = ConnectionManager.shared.loadToken() {
            headers["Authorization"] = token
            requestLogger.append(token)
        }
        
        requestLogger += ["", baseURL + url, method.rawValue]
        if let prettyString = parameters?.prettyString {
            requestLogger += ["", prettyString]
        }

        requestLogger += [""]
        self.requestString = requestLogger.joined(separator: "\n")
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
    
    var uploadRequest: UploadRequest {

//
//        let multipartFormData = MultipartFormData()
//
//        self.imageDict.forEach { name, image in
//            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: name , fileName: "file.jpeg", mimeType: "image/jpeg")
//        }
//
//        return Alamofire.upload(try! multipartFormData.encode(), to: baseURL + url, method: .post, headers: headers)

        return AF.upload(multipartFormData: { multipartFormData in
            self.imageDict.forEach { name, image in
                let data = image.resize(targetSize: .init(width: 300, height: 300))
                    .pngData()!
                multipartFormData.append(data, withName: name , fileName: "file.png", mimeType: "image/png")
            }
        }, to: baseURL + url, headers: headers)
    }
}

extension Router {
    func asObservable() -> Observable<T> {

        var responseLogger: [String] = [""]

        if let mockData = mockData {
            responseLogger += ["", "🔴 Mock Data 🔴"]
            return Observable.just(mockData)
        }


//        Alamofire.upload(multipartFormData: { multipartFormData in
//            self.imageDict.forEach { name, image in
//                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: name , fileName: "file.jpeg", mimeType: "image/jpeg")
//            }
//        }, to: baseURL + url, headers: headers,
//           encodingCompletion: { encodingResult in
//
//        })
//

        return Observable<T>.create { observer in

            let request = self.imageDict.isEmpty ? self.dataRequest : self.uploadRequest

            let session = request.responseData { result in

                defer {
                    let responseString = responseLogger.joined(separator: "\n")

                    let header = "┌─────────────────────────────┐"
                    let footer = "└─────────────────────────────┘"

                    let log: [String] = [
                        "",
                        header,
                        "",
                        "⭐️ Request ⭐️",
                        self.requestString,
                        "⭐️ Response ⭐️",
                        responseString,
                        footer,
                        "\n"
                    ]
                    Logger.info(log.joined(separator: "\n"))
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
                    observer.onError(StringError(message: "알려지지 않은 에러"))
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

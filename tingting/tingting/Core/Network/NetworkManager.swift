//
//  NetworkManager.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation

class NetworkManager {

    static func authenticateSchool(request: AddressAPIModel.RequestModel) -> Router<AddressAPIModel.ResponseModel> {
        return Router(url: "/local/search/address.json", method: .get, parameters: request)
    }
//
//
//
//    static func getCategoryAddress(request: CategoryAPIModel.RequestModel) -> Router<CategoryAPIModel.ResponseModel> {
//        return Router(url: "/local/search/category.json", method: .get, parameters: request)
//    }
    
    
    
    static func cancelAllRequest() {
       URLSession.shared.invalidateAndCancel()
    }
}

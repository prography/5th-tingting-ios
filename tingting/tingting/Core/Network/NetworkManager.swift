//
//  NetworkManager.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation

class NetworkManager {

    /// 학교인증 API (1)
    static func authenticateSchool(request: APIModel.School.Request) -> Router<CommonReponse> {
        return Router(url: "/api/v1/auth/school", method: .post, parameters: request)
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

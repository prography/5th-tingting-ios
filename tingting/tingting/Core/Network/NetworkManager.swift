//
//  NetworkManager.swift
//  tingting
//
//  Created by 김선우 on 9/3/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation

class NetworkManager {}

// Auth
extension NetworkManager {

    /// 학교인증 API (1)
    static func authenticateSchool(request: APIModel.School.Request) -> Router<CommonReponse> {
        return Router(url: "/auth/school", method: .post, parameters: request)
    }
    
    /// 학교인증 API (2)
    static func authenticateSchoolConfirm() -> Router<CommonReponse> {
        return Router(url: "/auth/school/confirm", method: .post)
    }
    
    /// 학교인증 API (3)
    static func authenticateSchoolComplete(email: String) -> Router<CommonReponse> {
        let params = ["email": email]
        return Router(url: "/auth/school/confirm", method: .get,parameters: params)
    }
    
    /// 소셜(카카오) 회원가입 --- 수정 중!
    static func kakaoLogin(email: String) -> Router<CommonReponse> {
        let params = ["email": email]
        return Router(url: "/auth/school/confirm", method: .get,parameters: params)
    }
    
    /// 로컬 로그인
    static func login(request: APIModel.Login.Request) -> Router<APIModel.Login.Response> {
        return Router(url: "/auth/local/login", method: .post, parameters: request)
    }
    
    /// 로컬 회원가입
    static func login(request: APIModel.SignUp.Request) -> Router<APIModel.SignUp.Response> {
        return Router(url: "/auth/local/signup", method: .post, parameters: request)
    }
    
    /// 아이디(로컬아이디) 중복확인
    static func checkDuplicate(loginID: String) -> Router<CommonReponse> {
        let params = ["local_id": loginID]
        return Router(url: "/auth/local/duplicate-id", method: .post, parameters: params)
    }
    
    /// 이름(닉네임) 중복확인
    static func checkDuplicate(name: String) -> Router<CommonReponse> {
        let params = ["name": name]
        return Router(url: "/auth/local/duplicate-name", method: .post, parameters: params)
    }
    
    /// 로그아웃 --- 미구현
    static func logout() -> Router<CommonReponse> {
        return Router(url: "/auth/logout", method: .get)
    }
}

// Profile
extension NetworkManager {
    
}

// Team
extension NetworkManager {
    
}

// Matching
extension NetworkManager {
    
}

extension NetworkManager {
    static func cancelAllRequest() {
        URLSession.shared.invalidateAndCancel()
    }
}

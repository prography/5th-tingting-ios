//
//  ConnectionManager.swift
//  tingting
//
//  Created by 김선우 on 12/19/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import Foundation

class ConnectionManager {
    
    static let shared: ConnectionManager = ConnectionManager()
    
    var currentUser: User?
    
    private let tokenKey = "TOKEN"
    
    var signUpRequest: APIModel.SignUp.Request = .init()
    
    // TODO: Add Logic
    var isLoginViewLoaded: Bool {
        return false
    }
 
    func saveToken(_ token: String) {
        UserDefaults().set(token, forKey: tokenKey)
    }
    
    func loadToken() -> String? {
        guard let token = UserDefaults().string(forKey: tokenKey) else { return nil }
        return token
    }
    
    func removeToken() {
        UserDefaults().set(nil, forKey: tokenKey)
    }
 
}

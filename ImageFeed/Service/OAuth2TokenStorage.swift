//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 04.06.2023.
//

import Foundation
class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}

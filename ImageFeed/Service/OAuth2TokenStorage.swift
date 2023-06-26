//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 04.06.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let token = newValue else {
                print("ОШИБКА! Не удалось записать токен")
                return
            }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
            guard isSuccess else {
                print("ОШИБКА! Не удалось записать токен")
                return
            }
        }
    }
}

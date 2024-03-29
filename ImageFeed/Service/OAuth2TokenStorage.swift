//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 04.06.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let newToken = newValue else {
                print("ОШИБКА! Не удалось записать токен")
                return
            }
            KeychainWrapper.standard.removeObject(forKey: tokenKey)
            let isSuccess = KeychainWrapper.standard.set(newToken, forKey: tokenKey)
            guard isSuccess else {
                print("ОШИБКА! Не удалось записать токен")
                return
            }
        }
    }
    
    func deleteToken() {
        let isSuccessDeleteToken = KeychainWrapper.standard.removeObject(forKey: tokenKey)
        if !isSuccessDeleteToken {
            print("Токен не удален")
        } else {
            print("Токен удален")
        }
    }
}

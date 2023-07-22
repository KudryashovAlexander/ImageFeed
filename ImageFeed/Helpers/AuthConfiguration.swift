//
//  Constants.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 27.05.2023.
//
import Foundation

//Параметры для 1 аккаунта
//let AccessKey = "kdWyscF3oWVhwwihqNKyEBQbnt0gipre2AzNaJMJfzA"
//let SecretKey = "d0B2iHojcV3FsQnWgNCLbrK9gKWF4mODeThqf8p9krM"

let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

// Параметры для 2 аккаунта
let AccessKey = "Xu17fU1JJ094xjRYM804wkJuinOoS5FKWM8fPbbym0o"
let SecretKey = "zStHc1o5MsWTEGJWYYdxH7pckzlhNZcaJQarqwSv1Eo"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURLString,
                                 defaultBaseURL: DefaultBaseURL)
    }
}

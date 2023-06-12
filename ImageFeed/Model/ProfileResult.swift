//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 12.06.2023.
//
import Foundation

struct ProfileResult: Codable {
    var userName: String
    var firstName: String
    var lastName: String
    var bio: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

//
//  UserResult.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 21.06.2023.
//

import UIKit
struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let medium: String
    }
}



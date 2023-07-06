//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 26.06.2023.
//

import UIKit

protocol DismissVC {
    func dismissVC()
}

final class TabBarViewController: UITabBarController, DismissVC {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.delegateDismiss = self
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
    func dismissVC() {
        dismiss(animated: true)
    }
    

}


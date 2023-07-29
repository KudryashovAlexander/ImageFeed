//
//  ProfileViewTest.swift
//  ProfileViewTest
//
//  Created by Александр Кудряшов on 18.07.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTest: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController
        
        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testProfileViewPresenterShowAlert() {
        
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let vc = UIViewController()
        
        //When
        presenter.showAlert(viewController: vc)
        
        //Then
        XCTAssertTrue(presenter.isAlertShow)
    }
    
    func testProfileViewControllerUpdateAvatar() {
        
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let url = DefaultBaseURL
                
        //When
        presenter.view?.updateAvatar(url: url)
        
        //Then
        XCTAssertTrue(viewController.isUpdateAvatar)
    }
    
    func testProfileViewControllerUpdateProfile() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let profile = Profile(username: "", firstName: "", lastName: nil, loginName: "", bio: nil)
                
        //When
        presenter.view?.updateProfileDetails(profile: profile)
        
        //Then
        XCTAssertTrue(viewController.isUpdateProfile)
    }


}

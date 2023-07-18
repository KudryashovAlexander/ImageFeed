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


}

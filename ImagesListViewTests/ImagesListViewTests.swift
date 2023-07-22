//
//  ImagesListViewTests.swift
//  ImagesListViewTests
//
//  Created by Александр Кудряшов on 18.07.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController
        
        //when
        viewController.viewDidLoad()

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }



}

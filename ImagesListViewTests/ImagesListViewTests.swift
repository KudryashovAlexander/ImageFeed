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
    
    func testViewReloadTableView() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController
        
        //when
        presenter.view?.reloadTableView()
        
        //then
        XCTAssertTrue(viewController.isReloadTableView)
    }
    
    func testChangePresenterCount(){
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController
        
        //when
        presenter.view?.updateTableViewAnimated(oldCount: 1, newCount: 3)
        
        //then
        XCTAssertTrue(viewController.isChangeCount)
        
    }



}

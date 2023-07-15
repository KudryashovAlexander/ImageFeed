//
//  WebViewPresenterSpy.swift
//  Image FeedTests
//
//  Created by Александр Кудряшов on 13.07.2023.
//

import ImageFeed
import Foundation

final class WebViewPresenterSpy: ImageFeed.WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImageFeed.WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

//
//  WebViewViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Александр Кудряшов on 14.07.2023.
//


import ImageFeed
import Foundation

final class WebViewViewControllerSpy: ImageFeed.WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}

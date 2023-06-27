//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 04.06.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private var logoImageView = UIImageView()

    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let xlock = NSLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        createLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIBlockingProgressHUD.show()
        if oauth2TokenStorage.token != nil {
            loadProfile()
        } else {
            showAuthViewController()
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.loadProfile()
            case .failure:
                self.showAlert()
                break
            }
        }
    }
}

extension SplashViewController {
    private func loadProfile() {
        if let token = OAuth2TokenStorage().token {
            
            profileService.fetchProfile(token) { result in

                switch result {
                case (.success(let profile)):
                    ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()

                case(.failure(let error)):
                    print(error)
                    UIBlockingProgressHUD.dismiss()
                    self.showAlert()
                }
            }
        }
    }
    
    private func showAlert() {
        UIBlockingProgressHUD.dismiss()
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default){[weak self] _ in
            self?.showAuthViewController()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAuthViewController() {
        if oauth2TokenStorage.token != nil {
            loadProfile()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            else {
                assertionFailure("Ошибка: AuthViewController")
                return
            }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
        }
    }
}

//MARK: - Extension 11 sprint - верстка кодом
extension SplashViewController {
    func createLogo() {
        logoImageView.center = view.center
        logoImageView.image = UIImage(named: "Logo_of_Unsplash")
        logoImageView.backgroundColor = .ypBlack
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
    }
}

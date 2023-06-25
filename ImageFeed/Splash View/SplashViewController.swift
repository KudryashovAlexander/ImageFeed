//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 04.06.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let seguaShowAutorization = "ShowAuthenticationScreenSegueIdentifier"
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if oauth2TokenStorage.token != nil {
            loadProfile()
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: seguaShowAutorization, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
}
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguaShowAutorization {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(seguaShowAutorization)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
                break
            }
        }
    }
}

extension SplashViewController {
    private func loadProfile() {
        if let token = OAuth2TokenStorage().token {
            
            profileService.fetchProfile(token) { [weak self] result in
                //TODO:  Следующая строка возвращает нил
//                guard let self else { return }
                switch result {
                case (.success(let profile)):
                    ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                    UIBlockingProgressHUD.dismiss()
                    
                case(.failure(let error)):
                    print(error)
                    UIBlockingProgressHUD.dismiss()
                    //TODO: Напиать метод обработки ошибки
                }
            }
        }
    }
    
    private func showAlert() {
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
        
            let authViewController = UIStoryboard(name: "Main", bundle: .main)
            guard let window = authViewController.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            else {
                assertionFailure("Ошибка инициализации AuthViewController")
                return
            }
            window.delegate = self
            window.modalPresentationStyle = .fullScreen
            present(window, animated: true)
    }
}

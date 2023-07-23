//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 15.07.2023.
//

import Foundation
import WebKit

//MARK: - Protocol
public protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewViewControllerProtocol? { get set }
    func showAlert(viewController: UIViewController)
    func viewDidLoad()
}


//MARK: - Class ProfileViewPresenter
class ProfileViewPresenter:ProfileViewPresenterProtocol {

    weak var view: ProfileViewViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var alertPresener = AlertPresener()
    private var oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
                self.view?.updateProfileDetails(profile: self.profileService.profile)
            }
        
            updateAvatar()
            view?.updateProfileDetails(profile: profileService.profile)
        
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return
        }
        print(profileImageURL)
        view?.updateAvatar(url: url)
    }
    
    func showAlert(viewController: UIViewController) {
        let alertModel = AlertModel(title: "Пока, пока!",
                                    message: "Уверены что хотите выйти?",
                                    buttonTitle: "Да",
                                    buttonTitle2: "Нет")
        
        alertPresener.showAlertTwoButton(model: alertModel, viewController: viewController) {
            self.oAuth2TokenStorage.deleteToken()
            self.clean()
            self.switchToSplashController()
        } actionTwo: {
            //Ничего не делать
        }
    }
    
    private func switchToSplashController() {
        UIBlockingProgressHUD.dismiss()

        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let splashVC = SplashViewController()
        window.rootViewController = splashVC
    }   
    
    private func clean() {
       // Очищаем все куки из хранилища.
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       // Запрашиваем все данные из локального хранилища.
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          // Массив полученных записей удаляем из хранилища.
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }
    
}

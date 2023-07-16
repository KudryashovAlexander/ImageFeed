import UIKit
import Kingfisher
import WebKit

//MARK: - Protocol
public protocol ProfileViewViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol? { get set }
    var avatarImageView: UIImageView { get set }
    var nameLabel: UILabel { get set }
    var loginNameLabel: UILabel { get set }
    var descriptionLabel: UILabel { get set }
    
    func viewDidLoad()
    func updateAvatar(url: URL)
    func updateProfileDetails(profile: Profile?)
}

//MARK: - Class ProfileViewController
class ProfileViewController: UIViewController, ProfileViewViewControllerProtocol {
    
    var avatarImageView = UIImageView()
    var nameLabel = UILabel()
    var loginNameLabel = UILabel()
    var descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    
    var presenter: ProfileViewPresenterProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        presenter?.viewDidLoad()
        
        createAvatarImageView(image: UIImage(named: "placeholder.jpg") ?? UIImage())
        createNameLabel(name: "нет данных")
        createLoginNameLabel(login: "нет данных")
        createDescriptionLabel(descrption: "нет данных")
        createLogoutButton()
    }
    
    private func createAvatarImageView(image: UIImage) {
        avatarImageView.image = image
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
    }
    
    private func createNameLabel(name: String) {
        nameLabel.text = name
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])

    }
    
    private func createLoginNameLabel(login: String) {
        loginNameLabel.text = login
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
        
    }
    
    private func createDescriptionLabel(descrption: String) {
        descriptionLabel.text = descrption
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
        
    }
    
    private func createLogoutButton() {
        let image = UIImage(named: "Logout_Button") ?? UIImage()
        logoutButton.setImage(image, for: .normal)
        logoutButton.addTarget(self, action: #selector (self.didTapLogoutButton), for: .touchUpInside)
        logoutButton.imageView?.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
    }
    
    func updateAvatar(url: URL) {
        avatarImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder.jpg"),
                options: [.processor(processor)])
    }
    
    func updateProfileDetails(profile: Profile?) {
        if let profile = profile {
            DispatchQueue.main.async {
                self.nameLabel.text = profile.name
                self.loginNameLabel.text = profile.loginName
                self.descriptionLabel.text = profile.bio
            }
        }
    }
    
    @objc
    private func didTapLogoutButton() {
        presenter?.showAlert(viewController: self)
    }
  
}

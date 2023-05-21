import UIKit

class ProfileViewController: UIViewController {
    
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    
    
    private var accountProfile = AccountModel(photo: UIImage(named: "profile_photo") ?? UIImage(),
                                              name: "Екатерина Новикова",
                                              login: "@ekaterina_nov",
                                              description: "Hello, world!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAvatarImageView(image: accountProfile.photo)
        createNameLabel(name: accountProfile.name)
        createLoginNameLabel(login: accountProfile.login)
        createDescriptionLabel(descrption: accountProfile.description)
        createLogoutButton()

    }
    
    private func createAvatarImageView(image: UIImage) {
        
        avatarImageView.image = image
        
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
        
        //FIXME: - Поправить шрифт!
        
        nameLabel.font = UIFont.systemFont(ofSize: 23)
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
        
        //FIXME: - Поправить шрифт!
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
        
        //FIXME: - Поправить шрифт!
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
    
    
    @objc
    private func didTapLogoutButton() {
        print("Logout Press")
    }
    
}

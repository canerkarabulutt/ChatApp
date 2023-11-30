//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Caner Karabulut on 9.11.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class RegisterViewController: UIViewController {
    //MARK: - Properties
    private var profileImageToUpload: UIImage?
    
    private var viewModel = RegisterViewModel()
    
    private lazy var profileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(handleProfilePhoto), for: .touchUpInside)
        return button
    }()
    private lazy var emailContainerView: AuthInputView = {
        let containerView = AuthInputView(image: UIImage(systemName: "envelope.fill")!, textField: emailTextField)
        return containerView
    }()
    private lazy var nameContainerView: AuthInputView = {
        let containerView = AuthInputView(image: UIImage(systemName: "person.fill")!, textField: nameTextField)
        return containerView
    }()
    private lazy var usernameContainerView: AuthInputView = {
        let containerView = AuthInputView(image: UIImage(systemName: "person.fill")!, textField: usernameTextField)
        return containerView
    }()
    private lazy var passwordContainerView: AuthInputView = {
        let containerView = AuthInputView(image: UIImage(systemName: "lock.fill")!, textField: passwordTextField)
        return containerView
    }()
    private var stackView = UIStackView()
    
    private let emailTextField = CustomTextField(placeHolder: "Email")
    private let nameTextField = CustomTextField(placeHolder: "Name")
    private let usernameTextField = CustomTextField(placeHolder: "Username")
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeHolder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .black
        button.isEnabled = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        return button
    }()
    private lazy var goLogInPage: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Go Log In Page", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleGoLogInView), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        view.backgroundColor = .red
    }
}
//MARK: - Selector
extension RegisterViewController {
    @objc private func handleRegisterButton(_ sender: UIButton) {
        guard let emailText = emailTextField.text else { return }
        guard let nameText = nameTextField.text else { return }
        guard let usernameText = usernameTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        guard let profileImage = profileImageToUpload else { return }
        
        let user = AuthServiceUser(emailText: emailText, nameText: nameText, passwordText: passwordText, usernameText: usernameText)
        showProgressHud(showProgress: true)

        AuthService.register(withUser: user, image: profileImage) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showProgressHud(showProgress: false)
                return
            }
            self.showProgressHud(showProgress: false)
            self.dismiss(animated: true)
        }
    }
    
    @objc private func handleProfilePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc private func handleTextFieldChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == nameTextField {
            viewModel.name = sender.text
        } else {
            viewModel.username = sender.text
        }
        registerButtonStatus()
    }
    @objc private func handleGoLogInView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleWillShowNotification() {
        self.view.frame.origin.y = -100
    }
    @objc private func handleWillHideNotification() {
        self.view.frame.origin.y = 0
    }
}
//MARK: - Helpers
extension RegisterViewController {
    
    private func registerButtonStatus() {
        if viewModel.status {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemBlue
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .black
        }
    }
    private func configureSetupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func style() {
        configureGradientLayer()
        configureSetupKeyboard()
        self.navigationController?.navigationBar.isHidden = true
        //profilePicture
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        //stack
        stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, nameContainerView, usernameContainerView, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //textChange
        emailTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        //switchPage
        goLogInPage.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(profileImageButton)
        view.addSubview(stackView)
        view.addSubview(goLogInPage)
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageButton.heightAnchor.constraint(equalToConstant: 150),
            profileImageButton.widthAnchor.constraint(equalToConstant: 150),
            profileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            goLogInPage.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            goLogInPage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            view.trailingAnchor.constraint(equalTo: goLogInPage.trailingAnchor, constant: 8)
        ])
    }
}
//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.profileImageToUpload = image
        profileImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        profileImageButton.layer.cornerRadius = 150 / 2
        profileImageButton.clipsToBounds = true
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        profileImageButton.layer.borderWidth = 2
        profileImageButton.contentMode = .scaleAspectFill
        self.dismiss(animated: true)
    }
}

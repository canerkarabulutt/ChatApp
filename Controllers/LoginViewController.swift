//
//  ViewController.swift
//  ChatApp
//
//  Created by Caner Karabulut on 9.11.2023.
//

import UIKit
import JGProgressHUD

class LoginViewController: UIViewController {
    //MARK: - Properties
    private var viewModel = LoginViewModel()
    
    private let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "ellipsis.message")
        imageView.tintColor = .white
        return imageView
    }()
    private lazy var emailContainerView: AuthInputView = {
        let containerView = AuthInputView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        return containerView
    }()
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField(placeHolder: "Email")
        return textField
    }()
    private lazy var passwordContainerView: AuthInputView = {
        let containerView = AuthInputView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
        return containerView
    }()
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeHolder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .black
        button.isEnabled = false
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        return button
    }()
    private lazy var goRegisterationPage: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Click To Become A Member", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleGoRegisterView), for: .touchUpInside)
        return button
    }()
    
    private var stackView = UIStackView()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        style()
        layout()
    }
}
//MARK: - Selector
extension LoginViewController {
    @objc private func handleLoginButton(_ sender: UIButton) {
        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        showProgressHud(showProgress: true)
        AuthService.login(withEmail: emailText, password: passwordText) { result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showProgressHud(showProgress: false)
                return
            }
            self.showProgressHud(showProgress: false)
            self.dismiss(animated: true)
        }
    }
    
    @objc private func handleTextFieldChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.emailTextField = sender.text
        } else {
            viewModel.passwordTextField = sender.text
        }
        loginButtonStatus()
    }
    
    @objc private func handleGoRegisterView(_ sender: UIButton) {
        let controller = RegisterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Helpers
extension LoginViewController {
    private func loginButtonStatus() {
        if viewModel.status {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemBlue
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .black
        }
    }
    
    private func style() {
        self.navigationController?.navigationBar.isHidden = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailContainerView.translatesAutoresizingMaskIntoConstraints = false
        stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        
        goRegisterationPage.translatesAutoresizingMaskIntoConstraints = false

        
    }
    private func layout() {
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        view.addSubview(goRegisterationPage)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            goRegisterationPage.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            goRegisterationPage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            view.trailingAnchor.constraint(equalTo: goRegisterationPage.trailingAnchor, constant: 8)
        ])
    }
}

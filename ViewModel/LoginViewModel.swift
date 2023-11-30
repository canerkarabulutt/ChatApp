//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Caner Karabulut on 9.11.2023.
//

import Foundation

struct LoginViewModel {
    var emailTextField: String?
    var passwordTextField: String?
    
    var status: Bool {
        return emailTextField?.isEmpty == false && passwordTextField?.isEmpty == false
    }
}

//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by Caner Karabulut on 9.11.2023.
//

import Foundation

struct RegisterViewModel {
    var email: String?
    var password: String?
    var username: String?
    var name: String?
    
    var status: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && username?.isEmpty == false && name?.isEmpty == false
    }
}

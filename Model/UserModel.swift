//
//  UserModel.swift
//  ChatApp
//
//  Created by Caner Karabulut on 13.11.2023.
//

import Foundation

struct UserModel {
    let uid: String
    let name: String
    let username: String
    let email: String
    let profileImageUrl: String
    
    init(data: [String : Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}

struct EndUser {
    let user: UserModel
    let message: MessageModel
}

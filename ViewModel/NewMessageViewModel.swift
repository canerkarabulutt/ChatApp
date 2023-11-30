//
//  MessageViewModel.swift
//  ChatApp
//
//  Created by Caner Karabulut on 15.11.2023.
//

import Foundation
import UIKit

struct NewMessageViewModel {
    
    private let message: MessageModel
    init(message: MessageModel) {
        self.message = message
    }
    var messageBackgroundColor: UIColor {
        return message.currentUser ? .systemBlue.withAlphaComponent(0.7): .systemPink.withAlphaComponent(0.7)
    }
    var currentUserActive: Bool {
        return message.currentUser
    }
    var profileImageView: URL? {
        return URL(string: message.user?.profileImageUrl ?? "")
    }
}

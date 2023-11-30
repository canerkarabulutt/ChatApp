//
//  MessageViewModel.swift
//  ChatApp
//
//  Created by Caner Karabulut on 16.11.2023.
//

import Foundation

struct MessageViewModel {
    private let endUser: EndUser
    init(endUser: EndUser) {
        self.endUser = endUser
    }
    var profileImage: URL? {
        return URL(string: endUser.user.profileImageUrl)
    }
    var timestampString: String {
        let date = endUser.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
}

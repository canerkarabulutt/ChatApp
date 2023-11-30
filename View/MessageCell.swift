//
//  MessageCell.swift
//  ChatApp
//
//  Created by Caner Karabulut on 16.11.2023.
//

import UIKit
import SDWebImage

class MessageCell: UITableViewCell {
    //MARK: - Properties
    var endUser: EndUser? {
        didSet { configureMessageCell() }
    }
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private let lastMessageLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    private var stackView = UIStackView()
    
    private let timeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.text = "5:5"
        return label
    }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension MessageCell {
    private func setup() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 60 / 2
        
        stackView = UIStackView(arrangedSubviews: [usernameLabel, lastMessageLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    private func layout() {
        addSubview(profileImageView)
        addSubview(stackView)
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 12),
            
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 8)
            
        ])
    }
    private func configureMessageCell() {
        guard let endUser = self.endUser else { return }
        let viewModel = MessageViewModel(endUser: endUser)
        self.usernameLabel.text = endUser.user.username
        self.lastMessageLabel.text = endUser.message.text
        self.profileImageView.sd_setImage(with: viewModel.profileImage)
        self.timeLabel.text = viewModel.timestampString
    }
}

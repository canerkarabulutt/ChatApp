//
//  UserCell.swift
//  ChatApp
//
//  Created by Caner Karabulut on 13.11.2023.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    //MARK: - Properties
    var user: UserModel? {
        didSet { configureUserCell() }
    }
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Title"
        return label
    }()
    private let subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Subtitle"
        label.textColor = .lightGray
        return label
    }()
    private var stackView = UIStackView()
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
extension UserCell {
    private func setup() {
        //profileImageView
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 60 / 2
        
        stackView = UIStackView(arrangedSubviews: [title, subTitle])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(profileImageView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 4),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
        ])
    }
    private func configureUserCell() {
        guard let user = user else { return }
        self.title.text = user.name
        self.profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        self.subTitle.text = user.username
    }
}

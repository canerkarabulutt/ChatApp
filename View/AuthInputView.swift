//
//  AuthInputView.swift
//  ChatApp
//
//  Created by Caner Karabulut on 9.11.2023.
//

import UIKit

class AuthInputView: UIView {
    init(image: UIImage, textField: UITextField) {
        super.init(frame: .zero)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .black
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dividerView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 26),
            imageView.heightAnchor.constraint(equalToConstant: 26),
            
            textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            
            dividerView.heightAnchor.constraint(equalToConstant: 0.8),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
       /* layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12 */
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

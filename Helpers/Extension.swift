//
//  BackgroundColor.swift
//  ChatApp
//
//  Created by Caner Karabulut on 9.11.2023.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.locations = [0,1]
        gradient.colors = [UIColor.systemMint.cgColor, UIColor.systemCyan.cgColor]
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    func showProgressHud(showProgress: Bool) {
        let progressHud = JGProgressHUD(style: .dark)
        progressHud.textLabel.text = "Please Wait..."
        if showProgress {
            progressHud.show(in: view)
        } else {
            progressHud.dismiss()
        }
        progressHud.dismiss(afterDelay: 2)
    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: self)
        self.view.removeFromSuperview()
        removeFromParent()
    }
}
extension UIView {
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.locations = [0,1]
        gradient.colors = [UIColor.systemMint.cgColor, UIColor.systemCyan.cgColor]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}

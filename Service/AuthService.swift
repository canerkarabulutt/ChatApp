//
//  AuthService.swift
//  ChatApp
//
//  Created by Caner Karabulut on 10.11.2023.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct AuthServiceUser {
    var emailText: String
    var nameText: String
    var passwordText: String
    var usernameText: String
}

struct AuthService {
    static func login(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func register(withUser user: AuthServiceUser, image: UIImage, completion: @escaping(Error?) -> Void ) {
        let photoName = UUID().uuidString
        guard let profileData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let referance = Storage.storage().reference(withPath: "media/profile_image/\(photoName).jpeg")
        referance.putData(profileData) { storageMeta, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
                referance.downloadURL { url, error in
                    if let error = error {
                        completion(error)
                    }
                    guard let profileImageUrl = url?.absoluteString else { return}
                    Auth.auth().createUser(withEmail: user.emailText, password: user.passwordText) { result, error in
                        if let error = error {
                            completion(error)
                        }
                        guard let userUid = result?.user.uid else { return }
                        let data = [
                            "email" : user.emailText,
                            "name" : user.nameText,
                            "username" : user.usernameText,
                            "profileImageUrl" : profileImageUrl,
                            "uid" : userUid
                        ] as [String : Any]
                        Firestore.firestore().collection("users").document(userUid).setData(data, completion: completion)
                            
                        }
                    }
                }
            }
        }

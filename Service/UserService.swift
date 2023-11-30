//
//  UserService.swift
//  ChatApp
//
//  Created by Caner Karabulut on 13.11.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct UserService {
    static func fetchUsers(completion: @escaping([UserModel]) -> Void) {
        
        var users = [UserModel]()
        
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            users = snapshot?.documents.map({ UserModel(data: $0.data())}) ?? []
            completion(users)
        }
    }
    //Kullanıcı verilerini almak için
    static func fetchUser(uid: String, completion: @escaping(UserModel) -> Void ) {
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            let user = UserModel(data: data)
            completion(user)
        }
    }
    static func fetchEndUsers(completion: @escaping([EndUser]) -> Void ) {
        var endUsers = [EndUser]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("messages").document(uid).collection("last-messages").order(by: "timestamp").addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ value in
                let data = value.document.data()
                let message = MessageModel(data: data)
                self.fetchUser(uid: message.toId) { user in
                    endUsers.append(EndUser(user: user, message: message))
                    completion(endUsers)
                }
            })
        }
    }
    
    static func sendMessage(message: String, toUser: UserModel, completion: @escaping(Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let data = [
            "text" : message,
            "fromId" : currentUid,
            "toId" : toUser.uid,
            "timestamp" : Timestamp(date: Date())
        ] as [String : Any]
        
        Firestore.firestore().collection("messages").document(currentUid).collection(toUser.uid).addDocument(data: data) { error in
            Firestore.firestore().collection("messages").document(toUser.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            Firestore.firestore().collection("messages").document(currentUid).collection("last-messages").document(toUser.uid).setData(data)
            Firestore.firestore().collection("messages").document(toUser.uid).collection("last-messages").document(currentUid).setData(data)
        }
        
    }
    static func fetchMessages(user: UserModel, completion: @escaping([MessageModel]) -> Void ) {
        var messages = [MessageModel]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("messages").document(currentUid).collection(user.uid).order(by: "timestamp").addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ value in
                if value.type == .added {
                    let data = value.document.data()
                    messages.append(MessageModel(data: data))
                    completion(messages)
                }
            })
        }
    }
}

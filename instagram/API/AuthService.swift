//
//  AuthService.swift
//  instagram
//
//  Created by Evaldas Paulauskas on 2021-04-18.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}

struct AuthService {
    
    static func loginUser(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping((Error?) -> Void)) {
        
        ImageUploader.uploadImage(image: credentials.profileImage) { (imageUrl) in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG: failed to create user \(error.localizedDescription)")
                    return
                }
                guard let uid = result?.user.uid else { return }
                let data: [String: Any] = [
                    "email": credentials.email,
                    "fullName": credentials.fullName,
                    "profileImageUrl": imageUrl,
                    "uid": uid,
                    "userName": credentials.userName
                ]
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            }
            
        }
        
    }
}


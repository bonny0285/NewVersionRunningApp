//
//  FirebaseDataSource.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 11/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase

class FirebaseDataSource {
    
    static let shared = FirebaseDataSource()
    
    //MARK: - Login Function

    func loginWithMailAndPassword(withEmail email: String,password: String, completion:@escaping (AuthDataResult?,Error?) -> ()){
        
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    completion(user, error)
            }
        }
    
    
    //MARK: - Create new User Function
    
    
    func createNewUser(withEmail email: String,password: String,username: String, completion: @escaping (AuthDataResult?,Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            completion(user,error)
        }
    }

    
    
    
    
    }


//
//  AutoLogin.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 12/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit


class AutoLogin {

    private let userDefaults = UserDefaults.standard
    var username: String? = nil
    var password: String? = nil

    init() {
        let check = self.checkingForCredential()
        
        guard check else { return }
        
        let user = self.retriveCredential()
        username = user.0
        password = user.1
    }
    
    func checkingForCredential() -> Bool {
        return userDefaults.bool(forKey: CHECK_DEFAULT)
    }
    
    func retriveCredential() -> (String, String) {
        var user: (email: String, password: String)
        user.email = userDefaults.object(forKey: EMAIL_DEFAULT) as! String
        user.password = userDefaults.object(forKey: PASSWORD_DEFAULT) as! String
        return user
    }
    
    func saveUserCredential(email: String, password: String) {
        userDefaults.set(email, forKey: EMAIL_DEFAULT)
        userDefaults.set(password, forKey: PASSWORD_DEFAULT)
        userDefaults.set(true, forKey: CHECK_DEFAULT)
        debugPrint("USER SALVATO",checkingForCredential())
    }
    
    func logout () {
        userDefaults.set(false, forKey: CHECK_DEFAULT)
    }
}

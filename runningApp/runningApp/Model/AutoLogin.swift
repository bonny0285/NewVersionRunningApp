//
//  AutoLogin.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 12/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit



class AutoLogin {
    
    static let share = AutoLogin()
    private var userDefault = UserDefaults.standard
    
    func checkAutoLogin () -> Bool {
        let check = userDefault.bool(forKey: CHECK_DEFAULT)
        return check
    }
    
    func retriveDataForLogin () -> (String, String) {
        var user: (email: String, password: String)
        user.email = userDefault.object(forKey: EMAIL_DEFAULT) as! String
        user.password = userDefault.object(forKey: PASSWORD_DEFAULT) as! String
        return user
    }

    
    func saveUser (email: String, password: String) {
        userDefault.set(email, forKey: EMAIL_DEFAULT)
        userDefault.set(password, forKey: PASSWORD_DEFAULT)
        userDefault.set(true, forKey: CHECK_DEFAULT)
    }
    
    
    func logout () {
        userDefault.set(false, forKey: CHECK_DEFAULT)
    }
}

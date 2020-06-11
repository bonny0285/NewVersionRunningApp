//
//  Alert.swift
//  runningApp
//
//  Created by Massimiliano on 13/11/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit


struct RunningAlert {
    
    
    private static func basicRunningAlert(on vc: UIViewController, whit title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    
    
    static func missingMail(on vc: UIViewController){
        basicRunningAlert(on: vc, whit: "Missing mail", message: "Please insert a valid Mail")
    }
    
    
    static func missingPassword(on vc: UIViewController){
        basicRunningAlert(on: vc, whit: "Missing password", message: "Please insert a valid Password.")
    }
    
    
    static func missingUsername(on vc: UIViewController){
        basicRunningAlert(on: vc, whit: "Missing Username", message: "Please insert a valid Username")
    }
    
    static func missingUsernameAndPassword(on vc: UIViewController){
        basicRunningAlert(on: vc, whit: "Attention empty fields", message: "Please insert a valid mail and password or create a new account.")
    }
    
    
    static func loginError(on vc: UIViewController){
        basicRunningAlert(on: vc, whit: "Login Error", message: "Please insert a valid username and password or create a new account.")
    }
    
    
    
    static func errorLikes(on vc: UIViewController){
        basicRunningAlert(on: vc, whit: "You can't press like twice!", message: "You have already pressed the like button")
    }
}

//
//  LoginVC.swift
//  runningApp
//
//  Created by Massimiliano on 25/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginVC: UIViewController {
    
    
    
    // Outlets
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // Actions
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        guard let email = emailTxt.text, let password = passwordTxt.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("Error signing in: \(error)")
            } else {
                self.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC")
                let mainVC = storyboard.instantiateViewController(withIdentifier: "Principale")
                self.present(mainVC, animated: true, completion: nil)
            }
        }
    }
    

}

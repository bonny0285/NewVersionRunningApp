//
//  LoginVC.swift
//  runningApp
//
//  Created by Massimiliano on 25/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit


class LoginVC: UIViewController {
    
    
    
    // Outlets
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var createUserBtn: UIButton!
    @IBOutlet var myLbl: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Gradients.myGradients(on: self, view: backgroundView)
        setupBackground(forView: emailTxt)
        setupBackground(forView: passwordTxt)
        setupBackground(forView: loginBtn)
        setupBackground(forView: createUserBtn)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function)
        Gradients.myGradients(on: self, view: backgroundView)
//        emailTxt.text = ""
//        passwordTxt.text = ""
        SetupUIElement.shared.setupUIElement(element: emailTxt)
        SetupUIElement.shared.setupUIElement(element: passwordTxt)
        SetupUIElement.shared.setupUIElement(element: loginBtn)
        SetupUIElement.shared.setupUIElement(element: createUserBtn)
//        setupBackground(forView: emailTxt)
//        setupBackground(forView: passwordTxt)
//        setupBackground(forView: loginBtn)
//        setupBackground(forView: createUserBtn)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        Gradients.myGradients(on: self, view: backgroundView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        Gradients.myGradients(on: self, view: backgroundView)
    }
    
    
    
    
    
    
    func setupBackground(forView view : UIView){
        view.layer.cornerRadius = 15
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    
    // Actions
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        
        if emailTxt.text == ""{
            RunningAlert.missingMail(on: self)
        } else if passwordTxt.text == ""{
            RunningAlert.missingPassword(on: self)
        } else if emailTxt.text == "" && passwordTxt.text == ""{
            RunningAlert.missingUsernameAndPassword(on: self)
        }
        
        
        guard let email = emailTxt.text, let password = passwordTxt.text else { return }
        
        
        FirebaseDataSource.shared.loginWithMailAndPassword(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                RunningAlert.loginError(on: self)
                debugPrint("Error signing in: \(error)")
            } else {
                self.emailTxt.textContentType = .username
                self.passwordTxt.textContentType = .password
                self.emailTxt.text = ""
                self.passwordTxt.text = ""
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyboard.instantiateViewController(withIdentifier: "Principale")
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: true, completion: nil)
            }
        }

        
    }
    
    
    
    @IBAction func createUserBtnWasPressed(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "createUserVC") as! CreateUserVC
        newVC.modalPresentationStyle = .fullScreen
        present(newVC, animated: true) {
            Gradients.myGradients(on: newVC, view: newVC.backgroundView)
        }
    }
    
    
}

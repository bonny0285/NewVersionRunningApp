//
//  CreateUserVC.swift
//  runningApp
//
//  Created by Massimiliano on 25/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class CreateUserVC: UIViewController {
    
    
    // Outlets
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var mailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Gradients.myGradients(on: self, view: backgroundView)
        
        SetupUIElement.shared.setupUIElement(element: usernameTxt)
        SetupUIElement.shared.setupUIElement(element: mailTxt)
        SetupUIElement.shared.setupUIElement(element: passwordTxt)
        SetupUIElement.shared.setupUIElement(element: createBtn)
        SetupUIElement.shared.setupUIElement(element: cancelBtn)

        // Do any additional setup after loading the view.
    }
    
    
    
    func setupBackground(forView view : UIView){
        view.layer.cornerRadius = 15
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    
    
    // Actions
    
    @IBAction func createBtnWasPressed(_ sender: Any) {
        
        
        if usernameTxt.text == ""{
            RunningAlert.missingUsername(on: self)
        } else if passwordTxt.text == ""{
            RunningAlert.missingPassword(on: self)
        } else if mailTxt.text == "" && passwordTxt.text == ""{
            RunningAlert.missingMail(on: self)
        }
        
        
        
        guard let email = mailTxt.text, let password = passwordTxt.text, let username = usernameTxt.text else { return }
        
        
        FirebaseDataSource.shared.createNewUser(withEmail: email, password: password, username: username) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                let changeProfile = user?.user.createProfileChangeRequest()
                
                changeProfile?.displayName = username
                
                changeProfile?.commitChanges(completion: { (error) in
                    if let error = error {
                        
                        debugPrint(error.localizedDescription)
                    }
                })
                
                
                guard let userID = user?.user.uid else { return }
                
                Firestore.firestore().collection(USERS_REF).document(userID).setData([
                    USERNAME : username,
                    DATE_CREATED : FieldValue.serverTimestamp()]
                    , completion: { (error) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                })
            }
        }

    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true) {
            Gradients.myGradients(on: vc, view: vc.backgroundView)
        }
    }
    
}

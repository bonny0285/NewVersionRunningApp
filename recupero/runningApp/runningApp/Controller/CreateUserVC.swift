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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // Actions
    
    @IBAction func createBtnWasPressed(_ sender: Any) {
        guard let email = mailTxt.text, let password = passwordTxt.text, let username = usernameTxt.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{debugPrint("Error creating user: \(error.localizedDescription)")
            } else {
                
                let changeProfile = user?.user.createProfileChangeRequest()
                
                changeProfile?.displayName = username
                print("il mio fucking utente",changeProfile)
                changeProfile?.commitChanges(completion: { (error) in
                    if let error = error {
                        print("cazzooooooooooooo")
                        debugPrint(error.localizedDescription)
                    }
                })
                
                
                guard let userID = user?.user.uid else { return }
                print("me cojoni")
                Firestore.firestore().collection(USERS_REF).document(userID).setData([
                    USERNAME : username,
                    DATE_CREATED : FieldValue.serverTimestamp()]
                    , completion: { (error) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                            //                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            //                        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                            //                        self.present(loginVC, animated: true, completion: nil)
                        }
                })
            }
        }
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

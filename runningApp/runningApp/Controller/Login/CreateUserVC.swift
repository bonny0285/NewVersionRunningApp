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


class CreateUserVC: UIViewController, MainCoordinated {
    
    
    
    
    //MARK: - Outlets

    @IBOutlet var usernameTextFiled: UITextField!
    @IBOutlet var mailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var createButton: UIButton! {
        didSet {
            createButton.setTitle(R.string.localizable.create_button(), for: .normal)
        }
    }
    
    @IBOutlet var cancelButton: UIButton! {
        didSet {
            cancelButton.setTitle(R.string.localizable.cancel_button(), for: .normal)
        }
    }
    
    @IBOutlet var backgroundView: UIView!
    
    //MARK: - Properties

    var mainCoordinator: MainCoordinator?
    var gradients: Gradients?
    var firebaseManager: FirebaseManager?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        firebaseManager = FirebaseManager()
        gradients = Gradients()
        gradients?.myGradients(on: self, view: backgroundView)
        
        usernameTextFiled.setupRunningView()
        mailTextField.setupRunningView()
        passwordTextField.setupRunningView()
        createButton.setupRunningView()
        cancelButton.setupRunningView()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
    }

    
    
    //MARK: - Actions

    
    @IBAction func createBtnWasPressed(_ sender: Any) {
        
        guard let email = usernameTextFiled.text else {
            RunningAlert.missingUsername(on: self)
            return
        }
        
        guard let password = passwordTextField.text else {
            RunningAlert.missingPassword(on: self)
            return
        }
        
        guard let username = mailTextField.text else {
            RunningAlert.missingMail(on: self)
            return
        }
        
//        if usernameTextFiled.text == ""{
//            RunningAlert.missingUsername(on: self)
//        } else if passwordTextField.text == ""{
//            RunningAlert.missingPassword(on: self)
//        } else if mailTextField.text == "" && passwordTextField.text == ""{
//            RunningAlert.missingMail(on: self)
//        }
//        guard let email = mailTextField.text, let password = passwordTextField.text, let username = usernameTextFiled.text else { return }
        
        firebaseManager?.createUser(email, password, completion: { [weak self] (user, error) in
            guard let self = self else { return }
            
            if let error = error {
                debugPrint(error.localizedDescription)
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
                            self.mainCoordinator?.creteUserDidSuccessfullyCreated(self)
                            //self.dismiss(animated: true, completion: nil)
                            
                        }
                })

            }
        })
        
//        FirebaseDataSource.shared.createNewUser(withEmail: email, password: password, username: username) {[weak self] (user, error) in
//            guard let self = self else { return }
//
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//
//                let changeProfile = user?.user.createProfileChangeRequest()
//
//                changeProfile?.displayName = username
//
//                changeProfile?.commitChanges(completion: { (error) in
//                    if let error = error {
//
//                        debugPrint(error.localizedDescription)
//                    }
//                })
//
//
//                guard let userID = user?.user.uid else { return }
//
//                Firestore.firestore().collection(USERS_REF).document(userID).setData([
//                    USERNAME : username,
//                    DATE_CREATED : FieldValue.serverTimestamp()]
//                    , completion: { (error) in
//                        if let error = error {
//                            debugPrint(error.localizedDescription)
//                        } else {
//                            self.dismiss(animated: true, completion: nil)
//
//                        }
//                })
//            }
//        }

    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        mainCoordinator?.popViewController(self)
    }
    
}

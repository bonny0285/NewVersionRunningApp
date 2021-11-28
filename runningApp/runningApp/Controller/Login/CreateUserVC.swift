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
        
        firebaseManager?.createUser(email, password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                let changeProfile = value.user.createProfileChangeRequest()
                changeProfile.displayName = username
                
                changeProfile.commitChanges { error in
                    if let error = error {
                        
                        debugPrint(error.localizedDescription)
                    }
                }
                
                let userID = value.user.uid
                
                Firestore.firestore().collection(USERS_REF)
                    .document(userID)
                    .setData([USERNAME : username, DATE_CREATED : FieldValue.serverTimestamp()]) { error in
                        
                                if let error = error {
                                    debugPrint(error.localizedDescription)
                                } else {
                                    self.mainCoordinator?.creteUserDidSuccessfullyCreated(self)
                                }
                             }
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        mainCoordinator?.popViewController(self)
    }
    
}

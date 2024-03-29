//
//  LoginVC.swift
//  runningApp
//
//  Created by Massimiliano on 25/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, MainCoordinated {
    
    
    
    
    
    //MARK: - Outlets
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton! {
        didSet {
            loginButton.setTitle(R.string.localizable.login(), for: .normal)
        }
    }
    
    @IBOutlet var createUserButton: UIButton! {
        didSet {
            createUserButton.setTitle(R.string.localizable.create_account(), for: .normal)
        }
    }
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var hintLabel: UILabel! {
        didSet {
            hintLabel.text = R.string.localizable.login_view_controller_hint()
        }
    }
    
    
    //MARK: - Properties
    
    var mainCoordinator: MainCoordinator?
    var gradients: Gradients?
    var autoLogin: AutoLogin?
    var firebaseManager: FirebaseManager?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogin = AutoLogin()
        firebaseManager = FirebaseManager()
        checkAutologin()
        
        
        //Gradients.myGradients(on: self, view: backgroundView)
        
        //        SetupUIElement.shared.setupUIElement(element: emailTxt)
        //        SetupUIElement.shared.setupUIElement(element: passwordTxt)
        //        SetupUIElement.shared.setupUIElement(element: loginBtn)
        //        SetupUIElement.shared.setupUIElement(element: createUserBtn)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        gradients = Gradients()
        gradients?.myGradients(on: self, view: backgroundView)
        emailTextField.setupRunningView()
        passwordTextField.setupRunningView()
        loginButton.setupRunningView()
        createUserButton.setupRunningView()
        
        hintLabel.text = R.string.localizable.dont_you_have_an_account()
        
        
        
        //Gradients.myGradients(on: self, view: backgroundView)
        emailTextField.text = ""
        passwordTextField.text = ""
        //        SetupUIElement.shared.setupUIElement(element: emailTxt)
        //        SetupUIElement.shared.setupUIElement(element: passwordTxt)
        //        SetupUIElement.shared.setupUIElement(element: loginBtn)
        //        SetupUIElement.shared.setupUIElement(element: createUserBtn)
    }
    
    
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        print(#function)
    //        Gradients.myGradients(on: self, view: backgroundView)
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        print(#function)
    //        Gradients.myGradients(on: self, view: backgroundView)
    //    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
    }
    
    
    //MARK: - Actions
    
    
    func checkAutologin(){
        
        guard let username = autoLogin?.username, let password = autoLogin?.password else { return }
        
        let coverView = createCoverView()
        view.addSubview(coverView)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        coverView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        firebaseManager?.loginWithMailAndPassword(username, password, completion: { [weak self] (user, error) in
            guard let self = self else { return }
            
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                coverView.removeFromSuperview()
                self.mainCoordinator?.loginViewControllerDidLogin(self)
            }
        })
        
        //            FirebaseDataSource.shared.loginWithMailAndPassword(withEmail: user.0, password: user.1) {[weak self] (user, error) in
        //                guard let self = self else { return }
        //
        //                if let error = error {
        //                    print(error.localizedDescription)
        //                } else {
        //                    self.emailTextField.text = ""
        //                    self.passwordTextField.text = ""
        //                    self.mainCoordinator?.loginViewControllerDidLogin(self)
        ////                    let storyboard = R.storyboard.main()
        ////                    let mainVC = storyboard.instantiateViewController(withIdentifier: "Principale")
        ////                    mainVC.modalPresentationStyle = .fullScreen
        ////                    self.present(mainVC, animated: true, completion: nil)
        //                }
        //            }
        
        
    }
    
    
    func createCoverView () -> UIView {
        let coverView = UIView()
        let indicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            // Fallback on earlier versions
        }
        indicator.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        coverView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: coverView.centerYAnchor, constant: 0).isActive = true
        indicator.centerXAnchor.constraint(equalTo: coverView.centerXAnchor, constant: 0).isActive = true
        coverView.backgroundColor = #colorLiteral(red: 0.9759346843, green: 0.5839473009, blue: 0.02618087828, alpha: 1)
        coverView.alpha = 0.9
        indicator.startAnimating()
        return coverView
    }
    
    
    // Actions
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        
        if emailTextField.text == ""{
            RunningAlert.missingMail(on: self)
        } else if passwordTextField.text == ""{
            RunningAlert.missingPassword(on: self)
        } else if emailTextField.text == "" && passwordTextField.text == ""{
            RunningAlert.missingUsernameAndPassword(on: self)
        }
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        firebaseManager?.loginWithMailAndPassword(email, password, completion: { [weak self] (user, error) in
            guard let self = self else { return }
            
            if let error = error {
                RunningAlert.loginError(on: self)
                debugPrint("Error signing in: \(error)")
            } else {
                
                self.autoLogin?.saveUserCredential(email: email, password: password)
                
                self.emailTextField.textContentType = .username
                self.passwordTextField.textContentType = .password
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.mainCoordinator?.loginViewControllerDidLogin(self)
            }
        })
        //        FirebaseDataSource.shared.loginWithMailAndPassword(withEmail: email, password: password) {[weak self] (user, error) in
        //            guard let self = self else { return }
        //
        //            if let error = error {
        //                RunningAlert.loginError(on: self)
        //                debugPrint("Error signing in: \(error)")
        //            } else {
        //
        //                self.autoLogin?.saveUserCredential(email: email, password: password)
        //
        //                self.emailTextField.textContentType = .username
        //                self.passwordTextField.textContentType = .password
        //                self.emailTextField.text = ""
        //                self.passwordTextField.text = ""
        //                self.mainCoordinator?.loginViewControllerDidLogin(self)
        ////                let storyboard = R.storyboard.main()
        ////                let mainVC = storyboard.instantiateViewController(withIdentifier: "Principale")
        ////                mainVC.modalPresentationStyle = .fullScreen
        ////                self.present(mainVC, animated: true, completion: nil)
        //            }
        //        }
        
        
    }
    
    
    
    @IBAction func createUserBtnWasPressed(_ sender: Any) {
        mainCoordinator?.loginViewControllerDidPressedCreateUser(self)
        //        let storyboard : UIStoryboard = R.storyboard.main()
        //        let newVC = storyboard.instantiateViewController(withIdentifier: "createUserVC") as! CreateUserVC
        //        newVC.modalPresentationStyle = .fullScreen
        //        present(newVC, animated: true) {
        //            Gradients.myGradients(on: newVC, view: newVC.backgroundView)
        //      }
    }
    
    
}

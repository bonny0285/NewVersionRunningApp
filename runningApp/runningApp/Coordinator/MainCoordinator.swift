//
//  MainCoordinator.swift
//  iOS13-Coordinator
//
//  Created by Massimiliano Bonafede on 10/09/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit

protocol MainCoordinated: class {
    var mainCoordinator: MainCoordinator? { get set}
}


class MainCoordinator: NSObject {
    
    let mainNavigationController:  UINavigationController
    var runningManager = RunningManager()
    
    
    init(navigationController: UINavigationController) {
        self.mainNavigationController = navigationController
        super.init()
        
        configure(viewController: mainNavigationController)
    }
    
    
    
    /// Common Functions
    func popViewController(_ viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    
    /// Login ViewController
    func loginViewControllerDidLogin(_ loginViewController: LoginViewController) {
        loginViewController.performSegue(withIdentifier: R.segue.loginViewController.showMain, sender: nil)
    }
    func loginViewControllerDidPressedCreateUser(_ loginViewController: LoginViewController) {
        loginViewController.performSegue(withIdentifier: R.segue.loginViewController.showCreateUser, sender: nil)
    }
    /// Create User ViewController
    func creteUserDidSuccessfullyCreated(_ createUserViewController: CreateUserVC) {
        createUserViewController.performSegue(withIdentifier: R.segue.createUserVC.showMain, sender: nil)
    }
    /// Main ViewController
    func mainViewControllerDidLogout() {}
    func mainViewControllerDidPressedRecords(_ mainViewController: MainViewController) {
        mainViewController.performSegue(withIdentifier: R.segue.mainViewController.showRecords, sender: nil)
    }
    /// Registro ViewController
    func registroViewControllerDidPressededComments(_ registroViewController: RegistroVC) {
        registroViewController.performSegue(withIdentifier: R.segue.registroVC.showComment, sender: nil)
    }
    
}


extension MainCoordinator: Coordinating {
    
    func configure(viewController: UIViewController) {
        (viewController as? MainCoordinated)?.mainCoordinator = self
        (viewController as? RunningManaged)?.runningManager = runningManager
        
        if let navigationController = viewController as? UINavigationController, let rootViewController = navigationController.viewControllers.first {
            configure(viewController: rootViewController)
        }
    }
}

//
//  MainNavigationController.swift
//  iOS13-Coordinator
//
//  Created by Massimiliano Bonafede on 10/09/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit


class MainNavigationController: UINavigationController, MainCoordinated {
    var mainCoordinator: MainCoordinator?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
    }
}

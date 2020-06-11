//
//  SetupUI.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 11/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit


class SetupUIElement {

    static let shared = SetupUIElement()
    
    func setupUIElement(element: UIView) {
        element.layer.cornerRadius = 15
        element.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        element.layer.shadowRadius = 5
        element.layer.shadowOpacity = 0.7
        element.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
}

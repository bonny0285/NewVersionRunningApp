//
//  MyGradients.swift
//  Gradients
//
//  Created by Massimiliano on 14/11/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit



class Gradients {
    
    //MARK: - Properties
    private var gradient = CAGradientLayer()
    
    
    //MARK: - Actions
    func myGradients(on vc: UIViewController, view : UIView){
        
        gradient.frame = vc.view.bounds // Whole view
        
        gradient.colors = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor(displayP3Red: 255/255.0, green: 185/255.0, blue: 0/255.0, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0) // Will start drawing gradient in top left corner
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0) // Will end drawing gradient in bottom right corner, therefore creating diagonal gradient
        
        gradient.locations = [0,0] // Location of the gradient stop, gets override by animation but it to initiate animation
        view.layer.addSublayer(gradient)
        //vc.view.layer.addSublayer(gradient)
        
        animateView()
        
    }
    
    
    private func animateView(){
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [-0.5, -0.25, 0]
        gradientAnimation.toValue = [1.0, 1.25, 1.5]
        gradientAnimation.duration = 5.0
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = Float.infinity // Forever
        self.gradient.add(gradientAnimation, forKey: nil)
    }
}

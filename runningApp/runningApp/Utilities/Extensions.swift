//
//  Extentions.swift
//  runningApp
//
//  Created by Massimiliano on 08/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit


extension Int {
    func formatTimeDurationToString() -> String{
        let durationHours = self / 3600
        let durationMinutes = (self % 3600) / 60
        let durationSeconds = (self % 3600) % 60
        
        
        if durationSeconds < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durationMinutes, durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
            }
        }
    }
}



extension Double{
    func metersToMiles(places: Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return ((self / 1000) * divisor).rounded() / divisor
    }
}


extension Double {
    func twoDecimalNumbers(place: Int) -> Double{
        let divisor = pow(10.0, Double(place))
        return (self * divisor).rounded() / divisor
    }
}

extension UIView {
    func setupRunningView() {
        self.layer.cornerRadius = 15
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
}

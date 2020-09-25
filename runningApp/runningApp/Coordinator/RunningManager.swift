//
//  RunningManager.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 25/09/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit

protocol RunningManaged: class {
    var runningManager: RunningManager? { get set }
}

class RunningManager {
    
    var run: Running? = nil
}

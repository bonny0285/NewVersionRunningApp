//
//  MainConsole.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 20/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit


protocol MainConsoleDelegate: class {
    func startButtonWasPressed()
    func pauseButtonWasPressed()
}


class MainConsole: UIView {

    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.backgroundColor = #colorLiteral(red: 0.9759346843, green: 0.5839473009, blue: 0.02618087828, alpha: 1).withAlphaComponent(0.5)
        }
    }
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.setTitle(R.string.localizable.start_running(), for: .normal)
            startButton.layer.cornerRadius = 10
            startButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            startButton.backgroundColor = #colorLiteral(red: 0.9759346843, green: 0.5839473009, blue: 0.02618087828, alpha: 1).withAlphaComponent(0.8)
        }
    }
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    
    var delegate: MainConsoleDelegate?
   
    var timeRunning: String? {
        timeLabel.text
    }
    var speedRunning: String? {
        speedLabel.text
    }
    var kmRunning: String? {
        kmLabel.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.setupRunningView()
        startButton.setupRunningView()
//        SetupUIElement.shared.setupUIElement(element: contentView)
//        SetupUIElement.shared.setupUIElement(element: startButton)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed( "MainConsole", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame = self.bounds
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo:  leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        startButton.setTitle(R.string.localizable.start_running(), for: .normal)
//        startButton.layer.cornerRadius = 10
//        startButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    
 
    @IBAction func startButtonWasPressed(_ sender: UIButton) {
        delegate?.startButtonWasPressed()
    }
    
    @IBAction func pauseButtonWasPressed(_ sender: UIButton) {
        delegate?.pauseButtonWasPressed()
    }
    
}



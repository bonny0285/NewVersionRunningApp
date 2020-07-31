//
//  MainVC.swift
//  runningApp
//
//  Created by Massimiliano on 07/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MainVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView! {
        didSet{
            mapDataSource = MapDataSource(mapView: mapView, username: username ?? "")
            mapDataSource.addDelegationOnMap()
            mapDataSource.checkLocationServices()
            mapDataSource.delegate = self
            mapDataSource.centerViewOnUserLocation()
            mapDataSource.locationManager.stopUpdatingLocation()
            mapDataSource.isEndRun = false
            mapDataSource.polylineLocation.removeAll()
            mapDataSource.startLocation = nil
            mapDataSource.lastLocation = nil
        }
    }
    @IBOutlet var blackView: UIView!
    @IBOutlet weak var logoutButtonOutlet: UIButton! {
        didSet {
            logoutButtonOutlet.setTitle(R.string.localizable.logout(), for: .normal)
        }
    }
    
    @IBOutlet var newBtn: UIButton! {
        didSet {
            newBtn.setTitle(R.string.localizable.new_run(), for: .normal)
        }
    }
    @IBOutlet weak var mainConsoleView: MainConsole! {
        didSet {
            mainConsoleView.delegate = self
            mainConsoleView.pauseButton.isHidden = true
        }
    }
    
    
    //MARK: - Properties
    
    fileprivate var state: State = .reset {
        didSet {
            switch state {
            case .start:
                debugPrint("start")
                checkState = true
                oraInizio = getCurrentTime
                
                mapDataSource.locationManager.startUpdatingLocation()
                
                startTimer()
                
                mainConsoleView.pauseButton.isHidden = false
                mainConsoleView.pauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
                mainConsoleView.startButton.setTitle(R.string.localizable.end_running(), for: .normal)
                mapDataSource.isEndRun = true
                mapDataSource.arrayGeo.removeAll()
                
            case .reset:
                debugPrint("reset")
                newBtn.isHidden = true
                blackView.isHidden = true
                
                mapDataSource.counter = 0
                
                time.invalidate()
                
                mapDataSource.isEndRun = false
                mapDataSource.polylineLocation.removeAll()
                mainConsoleView.speedLabel.text = "\(00.0)"
                mainConsoleView.kmLabel.text = "\(00.0)"
                mainConsoleView.timeLabel.text = "00:00"
                mainConsoleView.startButton.setTitle(R.string.localizable.start_running(), for: .normal)
                
            case .pause:
                debugPrint("pause")
                mapDataSource.startLocation = nil
                mapDataSource.lastLocation = nil
                time.invalidate()
                
                mapDataSource.locationManager.stopUpdatingLocation()
                mainConsoleView.pauseButton.setImage(UIImage(named: "resumeButton"), for: .normal)
                
            case .stop:
                debugPrint("stop")
                time.invalidate()
                checkState = false
                mapDataSource.locationManager.stopUpdatingLocation()
                mapDataSource.startLocation = nil
                mapDataSource.lastLocation = nil
                state = .pause
                alertExit()
                
                mapDataSource.polylineLocation.removeAll()
            }
        }
    }
    
    var getCurrentTime: String {
        var data = ""
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        data = "\(String(describing: components.hour!)):\(components.minute!):\(components.second!)"
        return data
    }
    
    var getCurrentData: String {
        var data = ""
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        data = "\(String(describing: components.day!))-\(components.month!)-\(components.year!)"
        return data
    }
    
    fileprivate var time = Timer()
    fileprivate var speed = 0
    fileprivate var speedDouble = 0.0
    fileprivate var checkState : Bool!
    fileprivate var oraInizio : String?
    fileprivate var oraFine : String?
    fileprivate var realTime = Timestamp()
    fileprivate var username : String? {
        Auth.auth().currentUser?.displayName
    }
    fileprivate var numComments = 0
    fileprivate var numLike = 0
    fileprivate var userLike : [String] = []
    fileprivate var handle : AuthStateDidChangeListenerHandle?
    fileprivate var run : Running!
    fileprivate var mapDataSource: MapDataSource!
    
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        newBtn.isHidden = true
        blackView.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mapDataSource.centerViewOnUserLocation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapDataSource.locationManager.stopUpdatingLocation()
    }
    
    // Actions
    
    
    @IBAction func newBtnWasPressed(_ sender: Any) {
        state = .reset
        mapDataSource.centerViewOnUserLocation()
        let overlays = mapDataSource?.map.overlays
        mapDataSource.map.removeOverlays(overlays!)
        mapDataSource.polylineLocation.removeAll()
        
    }
    
    
    @IBAction func centerUserLocationBtnPressed(_ sender: Any) {
    }
    
    
    
    
    @IBAction func logoutBtnWasPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            AutoLogin.share.logout()
            // dismiss(animated: true, completion: nil)
            let storyboard = R.storyboard.main()
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
            
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true) {
                Gradients.myGradients(on: loginVC, view: loginVC.backgroundView)
            }
            
            // self.present(loginVC, animated: true, completion: nil)
        } catch let signoutError as NSError{
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    
    
    
    // Functions
    
    
    
    //MARK: - Start Timer

    func startTimer() {
        mainConsoleView.timeLabel.text = mapDataSource.counter.formatTimeDurationToString()
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    
    //MARK: - Selector Update Counter

    @objc func updateCounter() {
        mapDataSource.counter += 1
        
        mainConsoleView.timeLabel.text = mapDataSource.counter.formatTimeDurationToString()
    }
    
    
    //MARK: - Calculate Speed

    func calculateSpeed(time seconds: Int, miles: Double) -> String{
        speed = Int(Double(seconds) / miles)
        return speed.formatTimeDurationToString()
    }
    
    
    //MARK: - Calculate Speed For Km

    func calculateSpeedForKm(time : Int, Km : Double)-> Double {
        speedDouble = Double(time) * Km
        return speedDouble
    }
    
    
    
    func alertExit() {
        let alert = UIAlertController(title: R.string.localizable.alert_terminate_session_title(), message: R.string.localizable.alert_terminate_session_message(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel_button(), style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        alert.addAction(UIAlertAction(title: R.string.localizable.ok_button(), style: .default, handler: { (UIAlertAction) in
            
            self.checkState = false
            self.oraFine = self.getCurrentTime
            
            self.mainConsoleView.pauseButton.isHidden = true
            
            self.newBtn.isHidden = false
            self.blackView.isHidden = false
            
            FirebaseDataSource.shared.saveDataOnFirebase(dataRunning: self.getCurrentData, oraInizio: self.oraInizio!, oraFine: self.oraFine!, kmTotali: self.mapDataSource.runDistance.metersToMiles(places: 3), speedMax: self.mapDataSource.speedMax.twoDecimalNumbers(place: 1), tempoTotale: self.mapDataSource.counter.formatTimeDurationToString(), arrayPercorso: self.mapDataSource.arrayGeo, latitudine: self.mapDataSource.latitudine, longitudine: self.mapDataSource.longitude, realDataRunning: self.realTime, username: self.username ?? "", numOfcomment: self.numComments, numOfLike: self.numLike, usersLikeit: self.userLike)
            
            self.mapDataSource.locationManager.stopUpdatingLocation()
            self.mapDataSource.polylineLocation.removeAll()
            
        }))
        
        self.present(alert,animated: true, completion: {
            //print("completion block")
        })
    }
    

    func calcolaMediaKM(km : [Double]) -> Double {
        
        var indice = 0
        var conta = 0.0
        for i in km{
            conta += i
            indice += 1
        }
        var risultato = conta / Double(indice)
        risultato = risultato * 3.6
        return risultato
    }
    
}

//MARK: - MapDataSourceProtocol

extension MainVC: MapDataSourceProtocol {
    
    func addTotalKm(km: String) {
        mainConsoleView.kmLabel.text = km
    }
    
    func addAvarageSpeed(speed: String) {
        mainConsoleView.speedLabel.text = speed
    }
    
}


//MARK: - MainConsoleDelegate

extension MainVC: MainConsoleDelegate {

    func startButtonWasPressed() {
        let startRunning = R.string.localizable.start_running()
        
        if mainConsoleView.startButton.titleLabel?.text == startRunning {
            mapDataSource.isEndRun = false
            state = .start
        } else {
            checkState = false
            state = .stop
        }
    }
    
    
    
    func pauseButtonWasPressed() {
        
        let endRun = R.string.localizable.end_running()
        let startRunning = R.string.localizable.start_running()
        
        if mainConsoleView.startButton.titleLabel?.text == endRun && time.isValid {
            mapDataSource.isEndRun = true
            state = .pause
        } else if mainConsoleView.startButton.titleLabel?.text == startRunning && time.isValid == false {
            mapDataSource.isEndRun = false
            print("nulla da fare")
        } else {
            mapDataSource.isEndRun = false
            state = .start
        }
    }

}


extension MainVC {
    
    enum State {
        case start
        case reset
        case pause
        case stop
    }
}

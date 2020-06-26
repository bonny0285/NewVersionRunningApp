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

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var blackView: UIView!
    @IBOutlet var newBtn: UIButton!
    @IBOutlet weak var mainConsoleView: MainConsole!
    
    
    //MARK: - Properties

    fileprivate var time = Timer()
    fileprivate var speed = 0
    fileprivate var speedDouble = 0.0
    fileprivate var checkState : Bool!
    fileprivate var oraInizio : String?
    fileprivate var oraFine : String?
    fileprivate var realTime = Timestamp()
    fileprivate var username : String = ""
    fileprivate var numComments = 0
    fileprivate var numLike = 0
    fileprivate var userLike : [String] = []
    fileprivate var handle : AuthStateDidChangeListenerHandle?
    fileprivate var run : Running!
    fileprivate var mapDataSource: MapDataSource!
    
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapDataSource = MapDataSource(mapView: mapView)
        mapDataSource.addDelegationOnMap()
        mapDataSource.checkLocationServices()
        mapDataSource.delegate = self
        
        mainConsoleView.delegate = self
        mainConsoleView.pauseButton.isHidden = true

        newBtn.isHidden = true
        blackView.isHidden = true

        username = Auth.auth().currentUser?.displayName! ?? ""
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        mapDataSource.centerViewOnUserLocation()
        mapDataSource.locationManager.stopUpdatingLocation()
        mapDataSource.isEndRun = false
        mapDataSource.polylineLocation.removeAll()
        mapDataSource.startLocation = nil
        mapDataSource.lastLocation = nil
        
        
        
        
        //        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
        //            if user == nil {
        //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
        //                self.present(loginVC, animated: true, completion: nil)
        //            } else {
        //                //self.setListener()
        //            }
        //        })
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function,"main")
    }
    
    // Actions
    
    
    @IBAction func newBtnWasPressed(_ sender: Any) {
        newRide()
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
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
    
    
    
    //MARK: - Start Run

    func startRun() {
        checkState = true
        oraInizio = getCurrentTime()
        
        mapDataSource.locationManager.startUpdatingLocation()
        
        startTimer()
        
        mainConsoleView.pauseButton.isHidden = false
        mainConsoleView.pauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
        mainConsoleView.startButton.setTitle("End Run", for: .normal)
        mapDataSource.isEndRun = true
        mapDataSource.arrayGeo.removeAll()
    }
    
    
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
    
    
    //MARK: - Pause

    func pauseRun() {
        
        mapDataSource.startLocation = nil
        mapDataSource.lastLocation = nil
        time.invalidate()
        
        mapDataSource.locationManager.stopUpdatingLocation()
        
        mainConsoleView.pauseButton.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
    
    //MARK: - End Run

    func endRun() {
        checkState = false
        
        mapDataSource.locationManager.stopUpdatingLocation()
        mapDataSource.startLocation = nil
        mapDataSource.lastLocation = nil
        
        pauseRun()
        alertExit()
        
        mapDataSource.polylineLocation.removeAll()
        
    }
    
    //MARK: - New Ride

    func newRide() {
        newBtn.isHidden = true
        blackView.isHidden = true
        
        mapDataSource.counter = 0
        
        time.invalidate()
        
        mainConsoleView.speedLabel.text = "\(00.0)"
        mainConsoleView.kmLabel.text = "\(00.0)"
        mainConsoleView.timeLabel.text = "00:00"
        mainConsoleView.startButton.setTitle("Start running", for: .normal)
        
        mapDataSource.isEndRun = false
        mapDataSource.polylineLocation.removeAll()
        
    }
    
    
    
    func alertExit() {
        let alert = UIAlertController(title: "Are you want terminate your session?", message: "Press 'Cancel' for stay or 'OK' for leave.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            self.checkState = false
            self.oraFine = self.getCurrentTime()
            
            self.mainConsoleView.pauseButton.isHidden = true
            
            self.newBtn.isHidden = false
            self.blackView.isHidden = false
            
            FirebaseDataSource.shared.saveDataOnFirebase(dataRunning: self.getCurrentData(), oraInizio: self.oraInizio!, oraFine: self.oraFine!, kmTotali: self.mapDataSource.runDistance.metersToMiles(places: 3), speedMax: self.mapDataSource.speedMax.twoDecimalNumbers(place: 1), tempoTotale: self.mapDataSource.counter.formatTimeDurationToString(), arrayPercorso: self.mapDataSource.arrayGeo, latitudine: self.mapDataSource.latitudine, longitudine: self.mapDataSource.longitude, realDataRunning: self.realTime, username: self.username, numOfcomment: self.numComments, numOfLike: self.numLike, usersLikeit: self.userLike)
            
            self.mapDataSource.locationManager.stopUpdatingLocation()
            self.mapDataSource.polylineLocation.removeAll()
            
        }))
        
        self.present(alert,animated: true, completion: {
            //print("completion block")
        })
    }
    
    func getCurrentTime() -> String {
        var data = ""
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        data = "\(String(describing: components.hour!)):\(components.minute!):\(components.second!)"
        return data
    }
    
    func getCurrentData() -> String {
        var data = ""
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        data = "\(String(describing: components.day!))-\(components.month!)-\(components.year!)"
        return data
    }
    
    func checkNumCommenti () {
        Firestore.firestore().collection(RUN_REFERENCE).document(run.documentID).collection(COMMENTS_REF).getDocuments { (snapshot, error) in
            guard let numeroCommenti = snapshot?.count else { return debugPrint("Error fetching comments: \(error!)") }
            self.numComments += numeroCommenti
        }
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
        if mainConsoleView.startButton.titleLabel?.text == "Start running"{
            mapDataSource.isEndRun = false
            startRun()
            
        } else {
            checkState = false
            endRun()
        }
    }
    
    
    
    func pauseButtonWasPressed() {
        if mainConsoleView.startButton.titleLabel?.text == "End Run" && time.isValid{
            mapDataSource.isEndRun = true
            pauseRun()
        } else if mainConsoleView.startButton.titleLabel?.text == "Start running" && time.isValid == false{
            mapDataSource.isEndRun = false
            print("nulla da fare")
        } else {
            mapDataSource.isEndRun = false
            startRun()
        }
    }
    
  
}

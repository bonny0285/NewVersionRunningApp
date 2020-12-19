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
import FirebaseFirestore

class MainViewController: UIViewController, MainCoordinated {
    var mainCoordinator: MainCoordinator?
    
    
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
                
                mainConsoleView.speed.isHidden = false
                mainConsoleView.total.isHidden = false
                mainConsoleView.kmLabel.isHidden = false
                mainConsoleView.speedLabel.isHidden = false
                mainConsoleView.timeLabel.isHidden = false
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
                mainConsoleView.total.isHidden = true
                mainConsoleView.speed.isHidden = true
                mainConsoleView.speedLabel.isHidden = true
                mainConsoleView.speedLabel.text = "\(00.0)"
                mainConsoleView.kmLabel.isHidden = true
                mainConsoleView.kmLabel.text = "\(00.0)"
                mainConsoleView.timeLabel.isHidden = true
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
    
    var autoLogin: AutoLogin?
    var firebaseManager: FirebaseManager?
    
    private var time = Timer()
    private var speed = 0
    private var speedDouble = 0.0
    private var checkState : Bool!
    private var oraInizio : String?
    private var oraFine : String?
    private var realTime = Timestamp()
    
    private var username : String? {
        Auth.auth().currentUser?.displayName
    }
    
    private var numComments = 0
    private var numLike = 0
    private var userLike : [String] = []
    private var handle : AuthStateDidChangeListenerHandle?
    private var run : Running!
    private var mapDataSource: MapDataSource!
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        let rightButton = UIBarButtonItem(title: "Result", style: .plain, target: self, action: #selector(navigationBarRightButtonPressed(_:)))
        navigationItem.rightBarButtonItem = rightButton
        let leftButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(navigationBarLeftButtonPressed(_:)))
        navigationItem.leftBarButtonItem = leftButton
        
        firebaseManager = FirebaseManager()
        autoLogin = AutoLogin()
        newBtn.isHidden = true
        blackView.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        state = .reset
        mapDataSource.locationManager.startUpdatingLocation()
        mapDataSource.centerViewOnUserLocation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapDataSource.locationManager.stopUpdatingLocation()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
    }
    
    
    
    //MARK: - Actions

    @objc func navigationBarRightButtonPressed(_ sender: UIBarButtonItem) {
        mainCoordinator?.mainViewControllerDidPressedRecords(self)
    }
    
    @objc func navigationBarLeftButtonPressed(_ sender: UIBarButtonItem) {
        firebaseManager?.logout(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.autoLogin?.logout()
                self.mainCoordinator?.popViewController(self)
            case .failure(let error):
                debugPrint("\(#function): \(error)")
            }
        })
    }
    
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
        
        firebaseManager?.logout(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.autoLogin?.logout()
                self.mainCoordinator?.popViewController(self)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        })
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

    func calculateSpeed(time seconds: Int, miles: Double) -> String {
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
            
            self.firebaseManager?.saveDataOnFirebase(dataRunning: self.getCurrentData, oraInizio: self.oraInizio!, oraFine: self.oraFine!, kmTotali: self.mapDataSource.runDistance.metersToMiles(places: 3), speedMax: self.mapDataSource.speedMax.twoDecimalNumbers(place: 1), tempoTotale: self.mapDataSource.counter.formatTimeDurationToString(), arrayPercorso: self.mapDataSource.arrayGeo, latitudine: self.mapDataSource.latitudine, longitudine: self.mapDataSource.longitude, realDataRunning: self.realTime, username: self.username ?? "Unknow", numOfcomment: self.numComments, numOfLike: self.numLike, usersLikeit: self.userLike)
            
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
        for i in km {
            conta += i
            indice += 1
        }
        //var risultato = conta / Double(indice)
        //risultato = risultato * 3.6
        return (conta / Double(indice)) * 3.6
    }
    
}

//MARK: - MapDataSourceProtocol

extension MainViewController: MapDataSourceProtocol {
    
    func addTotalKm(km: String) {
        mainConsoleView.kmLabel.text = km
    }
    
    func addAvarageSpeed(speed: String) {
        mainConsoleView.speedLabel.text = speed
    }
    
}


//MARK: - MainConsoleDelegate

extension MainViewController: MainConsoleDelegate {

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


extension MainViewController {
    
    enum State {
        case start
        case reset
        case pause
        case stop
    }
}

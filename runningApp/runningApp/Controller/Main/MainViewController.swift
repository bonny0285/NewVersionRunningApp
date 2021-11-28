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



enum State {
    case start
    case reset
    case pause
    case stop(withLogout: Bool)
}


class MainViewController: UIViewController, MainCoordinated {
    var mainCoordinator: MainCoordinator?
    
    
    //MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView!
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
                
                viewModel.locationManager.startUpdatingLocation()
                
                startTimer()
                
                mainConsoleView.speed.isHidden = false
                mainConsoleView.total.isHidden = false
                mainConsoleView.kmLabel.isHidden = false
                mainConsoleView.speedLabel.isHidden = false
                mainConsoleView.timeLabel.isHidden = false
                mainConsoleView.pauseButton.isHidden = false
                mainConsoleView.pauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
                mainConsoleView.startButton.setTitle(R.string.localizable.end_running(), for: .normal)
                viewModel.isEndRun = true
                viewModel.arrayGeo.removeAll()
                
            case .reset:
                debugPrint("reset")
                newBtn.isHidden = true
                blackView.isHidden = true
                
                viewModel.counter = 0
                
                time.invalidate()
                
                viewModel.isEndRun = false
                viewModel.polylineLocation.removeAll()
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
                viewModel.startLocation = nil
                viewModel.lastLocation = nil
                time.invalidate()
                
                viewModel.locationManager.stopUpdatingLocation()
                mainConsoleView.pauseButton.setImage(UIImage(named: "resumeButton"), for: .normal)
                
            case .stop(let logout):
                debugPrint("stop")
                time.invalidate()
                checkState = false
                viewModel.locationManager.stopUpdatingLocation()
                viewModel.startLocation = nil
                viewModel.lastLocation = nil
                state = .pause
                
                if logout == true {
                    
                } else {
                    willFinishSessionAlert()
                }
        
                viewModel.polylineLocation.removeAll()
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
    private var checkState: Bool!
    private var oraInizio: String?
    private var oraFine: String?
    private var realTime = Timestamp()
    
    private var username : String? {
        Auth.auth().currentUser?.displayName
    }
    
    //private var userLike : [String] = []
    //private var handle: AuthStateDidChangeListenerHandle?
    //private var run: Running!
   // private var mapDataSource: MapDataSource!
    
    lazy var viewModel: MapManager = {
        let viewModel = MapManager(mapView: mapView, username: username ?? "")
        viewModel.addDelegationOnMap()
        viewModel.checkLocationServices()
        viewModel.delegate = self
        viewModel.centerViewOnUserLocation()
        viewModel.locationManager.stopUpdatingLocation()
        viewModel.isEndRun = false
        viewModel.polylineLocation.removeAll()
        viewModel.startLocation = nil
        viewModel.lastLocation = nil
        return viewModel
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Result",
            style: .plain,
            target: self,
            action: #selector(navigationBarRightButtonPressed(_:))
        )
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self, action: #selector(navigationBarLeftButtonPressed(_:))
        )
        
        firebaseManager = FirebaseManager()
        autoLogin = AutoLogin()
        newBtn.isHidden = true
        blackView.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        state = .reset
        viewModel.locationManager.startUpdatingLocation()
        viewModel.centerViewOnUserLocation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.locationManager.stopUpdatingLocation()
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
        firebaseManager?.logout { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.autoLogin?.logout()
                self.mainCoordinator?.popViewController(self)
                
            case .failure(let error):
                debugPrint("\(#function): \(error)")
            }
        }
    }
    
    @IBAction func newBtnWasPressed(_ sender: Any) {
        state = .reset
        viewModel.centerViewOnUserLocation()
        let overlays = viewModel.map.overlays
        viewModel.map.removeOverlays(overlays)
        viewModel.polylineLocation.removeAll()
    }
    
    @IBAction func centerUserLocationBtnPressed(_ sender: Any) {}
    
    @IBAction func logoutBtnWasPressed(_ sender: Any) {
        
        state = .stop(withLogout: true)
        
        firebaseManager?.logout { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.autoLogin?.logout()
                self.mainCoordinator?.popViewController(self)
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }

    func startTimer() {
        mainConsoleView.timeLabel.text = viewModel.counter.formatTimeDurationToString()
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        viewModel.counter += 1
        mainConsoleView.timeLabel.text = viewModel.counter.formatTimeDurationToString()
    }
    
    #warning("check logout")
    func willLogout() {
        let alert = UIAlertController(title: R.string.localizable.alert_terminate_session_title(), message: R.string.localizable.alert_terminate_session_message(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
                            title: R.string.localizable.cancel_button(),
                            style: .cancel,
                            handler: nil)
        )
        
        alert.addAction(UIAlertAction(title: R.string.localizable.ok_button(), style: .default) { _ in
            
            self.checkState = false
            self.oraFine = self.getCurrentTime
            
            self.mainConsoleView.pauseButton.isHidden = true
            
            self.newBtn.isHidden = false
            self.blackView.isHidden = false
            
            self.firebaseManager?.saveDataOnFirebase(
                dataRunning: self.getCurrentData,
                oraInizio: self.oraInizio!,
                oraFine: self.oraFine!,
                kmTotali: self.viewModel.runDistance.metersToMiles(places: 3),
                speedMax: self.viewModel.speedMax.twoDecimalNumbers(place: 1),
                tempoTotale: self.viewModel.counter.formatTimeDurationToString(),
                arrayPercorso: self.viewModel.arrayGeo,
                latitudine: self.viewModel.latitudine,
                longitudine: self.viewModel.longitude,
                realDataRunning: self.realTime,
                username: self.username ?? "Unknow",
                numOfcomment: 0,
                numOfLike: 0,
                usersLikeit: []
            )
            
            self.viewModel.locationManager.stopUpdatingLocation()
            self.viewModel.polylineLocation.removeAll()
            
        })
        
        self.present(alert,animated: true) {
            //print("completion block")
        }
    }

 
    func willFinishSessionAlert() {
        let alert = UIAlertController(title: R.string.localizable.alert_terminate_session_title(), message: R.string.localizable.alert_terminate_session_message(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
                            title: R.string.localizable.cancel_button(),
                            style: .cancel,
                            handler: nil)
        )
        
        alert.addAction(UIAlertAction(title: R.string.localizable.ok_button(), style: .default) { _ in
            
            self.checkState = false
            self.oraFine = self.getCurrentTime
            
            self.mainConsoleView.pauseButton.isHidden = true
            
            self.newBtn.isHidden = false
            self.blackView.isHidden = false
            
            self.firebaseManager?.saveDataOnFirebase(
                dataRunning: self.getCurrentData,
                oraInizio: self.oraInizio!,
                oraFine: self.oraFine!,
                kmTotali: self.viewModel.runDistance.metersToMiles(places: 3),
                speedMax: self.viewModel.speedMax.twoDecimalNumbers(place: 1),
                tempoTotale: self.viewModel.counter.formatTimeDurationToString(),
                arrayPercorso: self.viewModel.arrayGeo,
                latitudine: self.viewModel.latitudine,
                longitudine: self.viewModel.longitude,
                realDataRunning: self.realTime,
                username: self.username ?? "Unknow",
                numOfcomment: 0,
                numOfLike: 0,
                usersLikeit: []
            )
            
            self.viewModel.locationManager.stopUpdatingLocation()
            self.viewModel.polylineLocation.removeAll()
            
        })
        
        self.present(alert,animated: true) {
            //print("completion block")
        }
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
            viewModel.isEndRun = false
            state = .start
            
        } else {
            checkState = false
            state = .stop(withLogout: false)
        }
    }
    
    
    
    func pauseButtonWasPressed() {
        
        let endRun = R.string.localizable.end_running()
        let startRunning = R.string.localizable.start_running()
    
        if mainConsoleView.startButton.titleLabel?.text == endRun && time.isValid {
            viewModel.isEndRun = true
            state = .pause
            
        } else if mainConsoleView.startButton.titleLabel?.text == startRunning && time.isValid == false {
            viewModel.isEndRun = false
            print("nulla da fare")
            
        } else {
            viewModel.isEndRun = false
            state = .start
        }
    }
}



/*
    func calcolaMediaKM(km : [Double]) -> Double {
        var totalKM = 0.0
        km.forEach { totalKM += $0 }
        return (totalKM / Double(km.count)) * 3.6
    }
*/


/*
func calculateSpeed(time seconds: Int, miles: Double) -> String {
    speed = Int(Double(seconds) / miles)
    return speed.formatTimeDurationToString()
}

func calculateSpeedForKm(time : Int, Km : Double) -> Double {
    speedDouble = Double(time) * Km
    return speedDouble
}
*/

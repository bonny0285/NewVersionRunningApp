//
//  MainVC.swift
//  runningApp
//
//  Created by Massimiliano on 07/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MainVC: UIViewController, MKMapViewDelegate{
    
    
    // Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var startEndBtn: UIButton!
    @IBOutlet var timerRunLbl: UILabel!
    @IBOutlet var avarageSpeedLbl: UILabel!
    @IBOutlet var totalKmLbl: UILabel!
    @IBOutlet var pauseResumeBtn: UIButton!
    @IBOutlet var blackView: UIView!
    @IBOutlet var newBtn: UIButton!
    
    
    // Variables

    fileprivate var time = Timer()
    fileprivate var speed = 0
    fileprivate var speedDouble = 0.0
    fileprivate var myBool : Bool!
    fileprivate var oraInizio : String?
    fileprivate var oraFine : String?
    fileprivate var realTime = Timestamp()
    fileprivate var username : String = ""
    fileprivate var numComments = 0
    fileprivate var numLike = 0
    fileprivate var userLike : [String] = []
    private var handle : AuthStateDidChangeListenerHandle?
    fileprivate var run : Running!
    
    
    var mapDataSource: MapDataSource!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapDataSource = MapDataSource(mapView: mapView)
        mapDataSource.addDelegationOnMap()
        mapDataSource.checkLocationServices()
        mapDataSource.delegate = self
 
        pauseResumeBtn.isHidden = true
        newBtn.isHidden = true
        blackView.isHidden = true
        startEndBtn.layer.cornerRadius = 10
        startEndBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
    
    
    @IBAction func startEndBtnPressed(_ sender: Any) {
        if startEndBtn.titleLabel?.text == "Start running"{
            mapDataSource.isEndRun = false
            startRun()
            
        } else {
            myBool = false
            endRun()
        }
        
    }
    
    @IBAction func pauseResumeBtnPressed(_ sender: Any) {
        
        if startEndBtn.titleLabel?.text == "End Run" && time.isValid{
            mapDataSource.isEndRun = true
            pauseRun()
        } else if startEndBtn.titleLabel?.text == "Start running" && time.isValid == false{
            mapDataSource.isEndRun = false
            print("nulla da fare")
        } else {
            mapDataSource.isEndRun = false
            startRun()
        }
    }
    
    
    @IBAction func logoutBtnWasPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
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
    func startRun() {
        myBool = true
        oraInizio = getCurrentTime()
        
        mapDataSource.locationManager.startUpdatingLocation()
        
        startTimer()
        pauseResumeBtn.isHidden = false
        pauseResumeBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
        startEndBtn.setTitle("End Run", for: .normal)
        mapDataSource.isEndRun = true
        mapDataSource.arrayGeo.removeAll()
    }
    
    func startTimer() {
        timerRunLbl.text = mapDataSource.counter.formatTimeDurationToString()
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        mapDataSource.counter += 1
        timerRunLbl.text = mapDataSource.counter.formatTimeDurationToString()
    }
    
    
    func calculateSpeed(time seconds: Int, miles: Double) -> String{
        speed = Int(Double(seconds) / miles)
        return speed.formatTimeDurationToString()
    }
    
    func calculateSpeedForKm(time : Int, Km : Double)-> Double {
        speedDouble = Double(time) * Km
        return speedDouble
    }
    
    func pauseRun() {
        
        mapDataSource.startLocation = nil
        mapDataSource.lastLocation = nil
        time.invalidate()
        
        mapDataSource.locationManager.stopUpdatingLocation()
        
        pauseResumeBtn.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
    
    func endRun() {
        myBool = false
        
        mapDataSource.locationManager.stopUpdatingLocation()
        
        mapDataSource.startLocation = nil
        mapDataSource.lastLocation = nil
        
        pauseRun()
        alertExit()
        
        mapDataSource.polylineLocation.removeAll()
       
    }
    
    func newRide() {
        newBtn.isHidden = true
        blackView.isHidden = true
        
        mapDataSource.counter = 0
        
        time.invalidate()
        avarageSpeedLbl.text = "\(00.0)"
        totalKmLbl.text = "\(00.0)"
        timerRunLbl.text = "00:00"
        startEndBtn.setTitle("Start running", for: .normal)
        
        mapDataSource.isEndRun = false
        mapDataSource.polylineLocation.removeAll()
      
    }
    
    
    
    func alertExit() {
        let alert = UIAlertController(title: "Are you want terminate your session?", message: "Press 'Cancel' for stay or 'OK' for leave.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            self.myBool = false
            self.oraFine = self.getCurrentTime()
            self.pauseResumeBtn.isHidden = true
            self.newBtn.isHidden = false
            self.blackView.isHidden = false
            self.saveOnDB()
            
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
    
    func saveOnDB() {
      
        Firestore.firestore().collection(RUN_REFERENCE).addDocument(data: [
            DATA_RUNNING : getCurrentData(),
            ORA_INIZIO : oraInizio!,
            ORA_FINE : oraFine!,
            KM_TOTALI : mapDataSource.runDistance.metersToMiles(places: 3),
            SPEED_MAX : mapDataSource.speedMax.twoDecimalNumbers(place: 1),
            TOTALE_TEMPO : mapDataSource.counter.formatTimeDurationToString(),
            ARRAY_PERCORSO : mapDataSource.arrayGeo,
            LATITUDINE : mapDataSource.latitudine,
            LONGITUDINE : mapDataSource.longitude,
            REAL_DATA_RUNNING : realTime,
            USERNAME : username,
            NUMBER_OF_COMMENTS : numComments,
            NUMBER_OF_LIKE : numLike,
            USER_LIKE : userLike
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                //print("Document added with ID: \(ref!.documentID)")
            }
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


extension MainVC: MapDataSourceProtocol {

    func addTotalKm(km: String) {
        totalKmLbl.text = km
    }
    
    func addAvarageSpeed(speed: String) {
        avarageSpeedLbl.text = speed
    }

}

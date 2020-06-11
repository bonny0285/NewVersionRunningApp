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
    fileprivate let locationManager = CLLocationManager()
    fileprivate let regionMeter : Double = 1000
    fileprivate var time = Timer()
    fileprivate var counter = 0
    fileprivate var speed = 0
    fileprivate var speedDouble = 0.0
    fileprivate var startLocation : CLLocation!
    fileprivate var lastLocation : CLLocation!
    fileprivate var runDistance = 0.0
    fileprivate var polylineLocation = [CLLocationCoordinate2D]()
    fileprivate var myBool : Bool!
    fileprivate var ref: DocumentReference? = nil
    fileprivate var arrayKM = [Double]()
    fileprivate var dataRun = NSDate()
    fileprivate var giornoInizio : String?
    fileprivate var oraInizio : String?
    fileprivate var oraFine : String?
    fileprivate var speedMax : Double = 0.0
    fileprivate var arrayGeo = [GeoPoint?]()
    fileprivate var latitudine : Double = 0.0
    fileprivate var longitude : Double = 0.0
    fileprivate var realTime = Timestamp()
    fileprivate var username : String = ""
    fileprivate var numComments = 0
    fileprivate var numLike = 0
    fileprivate var userLike : [String] = []
    private var handle : AuthStateDidChangeListenerHandle?
    var run : Running!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
        pauseResumeBtn.isHidden = true
        newBtn.isHidden = true
        blackView.isHidden = true
        startEndBtn.layer.cornerRadius = 10
        startEndBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        username = Auth.auth().currentUser?.displayName! ?? ""
        print("USERNAME CORRENTE", username)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            } else {
                //self.setListener()
            }
        })
        
        
    }
    
    
//    func setListener(){
//
//        if selectedCategory == ThoughtCategory.popular.rawValue{
//            thoughtListener = thoughtCollectionRef
//                .order(by: NUM_LIKES, descending: true)
//                .addSnapshotListener { (snapshot, error) in
//                    if let err = error {
//                        debugPrint("Error fetching docs: \(err)")
//                    } else{
//                        self.thoughts.removeAll()
//                        self.thoughts = Thought.parseData(snapshot: snapshot)
//                        self.tableView.reloadData()
//                    }
//            }
//        } else {
//            thoughtListener = thoughtCollectionRef
//                .whereField(CATEGORY, isEqualTo: selectedCategory)
//                .order(by: TIME_STAMP, descending: true)
//                .addSnapshotListener { (snapshot, error) in
//                    if let err = error {
//                        debugPrint("Error fetching docs: \(err)")
//                    } else{
//                        self.thoughts.removeAll()
//                        self.thoughts = Thought.parseData(snapshot: snapshot)
//                        self.tableView.reloadData()
//                    }
//            }
//        }
//    }
    
    
    // Actions
    
    @IBAction func newBtnWasPressed(_ sender: Any) {
        newRide()
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        polylineLocation.removeAll()
    }
    
    
    @IBAction func centerUserLocationBtnPressed(_ sender: Any) {
    }
    
    
    @IBAction func startEndBtnPressed(_ sender: Any) {
        if startEndBtn.titleLabel?.text == "Start running"{
            startRun()
            
        } else {
            myBool = false
            endRun()
        }
        
    }
    
    @IBAction func pauseResumeBtnPressed(_ sender: Any) {
        
        if startEndBtn.titleLabel?.text == "End Run" && time.isValid{
            pauseRun()
        } else if startEndBtn.titleLabel?.text == "Start running" && time.isValid == false{
            print("nulla da fare")
        } else {
            startRun()
        }
    }
    
    
    @IBAction func logoutBtnWasPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError{
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    
    
    
    // Functions
    func startRun(){
        myBool = true
        oraInizio = getCurrentTime()
        locationManager.startUpdatingLocation()
        startTimer()
        pauseResumeBtn.isHidden = false
        pauseResumeBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
        startEndBtn.setTitle("End Run", for: .normal)
        
        arrayGeo.removeAll()
    }
    
    func startTimer(){
        timerRunLbl.text = counter.formatTimeDurationToString()
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(){
        counter += 1
        timerRunLbl.text = counter.formatTimeDurationToString()
    }
    
    
    func calculateSpeed(time seconds: Int, miles: Double) -> String{
        speed = Int(Double(seconds) / miles)
        return speed.formatTimeDurationToString()
    }
    
    func calculateSpeedForKm(time : Int, Km : Double)-> Double {
        speedDouble = Double(time) * Km
        return speedDouble
    }
    
    func pauseRun(){
        startLocation = nil
        lastLocation = nil
        time.invalidate()
        locationManager.stopUpdatingLocation()
        pauseResumeBtn.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
    
    func endRun(){
        myBool = false
        locationManager.stopUpdatingLocation()
        startLocation = nil
        lastLocation = nil
        // add our object to Realm
        pauseRun()
        alertExit()
        polylineLocation.removeAll()
        //pauseResumeBtn.isHidden = true
        //Run.addRUnToReal(pace: pace, distance: runDistance, duration: counter, locations: coordinateLocations)
        //print("coooordinate\(coordinateLocations.first)")
       // let fine = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
       
    }
    
    func newRide(){
        newBtn.isHidden = true
        blackView.isHidden = true
        counter = 0
        time.invalidate()
        avarageSpeedLbl.text = "\(00.0)"
        totalKmLbl.text = "\(00.0)"
        timerRunLbl.text = "00:00"
        startEndBtn.setTitle("Start running", for: .normal)
        polylineLocation.removeAll()
        //locationManager.startUpdatingLocation()
    }
    
    
    
    func alertExit(){
        let alert = UIAlertController(title: "Are you want terminate your session?", message: "Press 'Cancel' for stay or 'OK' for leave.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            //print("Cancel")
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            //print("Exit")
            self.myBool = false
            self.oraFine = self.getCurrentTime()
            self.pauseResumeBtn.isHidden = true
            self.newBtn.isHidden = false
            self.blackView.isHidden = false
            self.saveOnDB()
            self.locationManager.stopUpdatingLocation()
            self.polylineLocation.removeAll()
        }))
        
        self.present(alert,animated: true, completion: {
            //print("completion block")
        })
    }
    
    func getCurrentTime()-> String{
        var data = ""
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        data = "\(String(describing: components.hour!)):\(components.minute!):\(components.second!)"
        return data
    }
    
    func getCurrentData() -> String{
        var data = ""
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        data = "\(String(describing: components.day!))-\(components.month!)-\(components.year!)"
        return data
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorizzation()
        } else {
            // show alert letting the user know they have to turn this on
        }
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorizzation(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // show alert not allowed
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // show alert instruction them how to turn on permission
            break
        }
    }
    
    
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeter, longitudinalMeters: regionMeter)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkNumCommenti (){
      //  var run : Running!
         Firestore.firestore().collection(RUN_REFERENCE).document(run.documentID).collection(COMMENTS_REF).getDocuments { (snapshot, error) in
            guard let numeroCommenti = snapshot?.count else { return debugPrint("Error fetching comments: \(error!)") }
            self.numComments += numeroCommenti
        }
    }
    
    func saveOnDB(){
       // checkNumCommenti()
        Firestore.firestore().collection(RUN_REFERENCE).addDocument(data: [
            DATA_RUNNING : getCurrentData(),
            ORA_INIZIO : oraInizio!,
            ORA_FINE : oraFine!,
            KM_TOTALI : runDistance.metersToMiles(places: 3),
            SPEED_MAX : speedMax.twoDecimalNumbers(place: 1),
            TOTALE_TEMPO : counter.formatTimeDurationToString(),
            ARRAY_PERCORSO : arrayGeo,
            LATITUDINE : latitudine,
            LONGITUDINE : longitude,
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
    
    
    func calcolaMediaKM(km : [Double]) -> Double{
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




extension MainVC : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard let locationFirst = locations.first else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionMeter, longitudinalMeters: regionMeter)
        mapView.setRegion(region, animated: true)
        //mapView.setCenter(center, animated: true)
        
        
        
        if startEndBtn.titleLabel?.text == "End Run"{
            
            latitudine = locationFirst.coordinate.latitude
            longitude = locationFirst.coordinate.longitude
           // getPolyline(polylineCoordinate: center)
            let inizio = CLLocationCoordinate2D(latitude: locationFirst.coordinate.latitude, longitude: locationFirst.coordinate.longitude)
            let fine = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
           // drawTrack(inizio: inizio,fine: fine)
            drawLine(startCoordinate: inizio,endingRun: fine)
            
        if startLocation == nil {
            startLocation = locations.first
        } else if let locations = locations.last {
            runDistance += lastLocation.distance(from: locations)
            
//          let newLocation = Location(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
//            print("newww location\(newLocation)")
           // coordinateLocations.insert(newLocation, at: 0)
            totalKmLbl.text = "\(runDistance.metersToMiles(places: 3))"
            if counter > 0 && runDistance > 0 {
                arrayKM.append(lastLocation.speed)
                avarageSpeedLbl.text = "\((lastLocation.speed * 3.6).twoDecimalNumbers(place: 1)) Km/h"
                print("ARRAY KM",arrayKM)
               // speedMax = arrayKM.max()! * 3.6
                speedMax = calcolaMediaKM(km: arrayKM)
//                avarageSpeedLbl.text = "\(calculateSpeedForKm(time: counter, Km: runDistance.metersToMiles(places: 1)))"
                //avarageSpeedLbl.text = calculateSpeed(time: counter, miles: runDistance.metersToMiles(places: 3))
            }
        }
        lastLocation = locations.last
        } else {
            // check this function
           
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizzation()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if (overlay is MKPolyline){
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            polylineRender.strokeColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            polylineRender.lineWidth = 3
            return polylineRender
        }
        return MKOverlayRenderer()
    }

    
    
    
    func drawLine(startCoordinate : CLLocationCoordinate2D, endingRun : CLLocationCoordinate2D){
    
        polylineLocation.append(startCoordinate)
        //arrayGeo.append(CLLocationCoordinate2D(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude))
        arrayGeo.append(GeoPoint(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude))
//        let startPlacemark = MKPlacemark(coordinate: polylineLocation.first!)
//        let endPlacemark = MKPlacemark(coordinate: polylineLocation.last!)
        let aPolyline = MKPolyline(coordinates: polylineLocation, count: polylineLocation.count)
        self.mapView.addOverlay(aPolyline)
    }
    

}

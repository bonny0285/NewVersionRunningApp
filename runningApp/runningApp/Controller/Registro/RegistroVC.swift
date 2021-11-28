//
//  ViewController.swift
//  runningApp
//
//  Created by Massimiliano on 07/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseFirestore




class RegistroVC: UIViewController, MKMapViewDelegate, MainCoordinated, RunningManaged {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    
    //MARK: - Properties
    
    private var runListener : ListenerRegistration!
    private var runs = [Running]()
    private var datiDaPassare : Running?
    
    private var runCollectionRef: CollectionReference! {
        Firestore.firestore().collection(RUN_REFERENCE)
    }
    
    private var handle : AuthStateDidChangeListenerHandle?
    private let regionMeter : Double = 1000
    private let locationManager = CLLocationManager()
    private var dataSource: RegistroDataSource!
    var mainCoordinator: MainCoordinator?
    var runningManager: RunningManager?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(R.nib.runningSavedCell)
        tableView.delegate = self
        mapView.delegate = self
        setListener()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setListener()
        dataSource = RegistroDataSource(running: runs)
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard runListener != nil else { return }
        
        runListener.remove()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
    }
    
    //MARK: - Actions
    
    func refresh (){
        Firestore.firestore().collection(RUN_REFERENCE).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            guard let snapshot = snapshot else {
                debugPrint("Error fetching comments: \(error!)")
                return
            }
            
            self.runs.removeAll()
            self.runs = Running.parseData(snapshot: snapshot)
            self.tableView.reloadData()
        }
    }
    
    
    func setListener(){
        runListener = runCollectionRef
            .order(by: REAL_DATA_RUNNING, descending: true)
            .addSnapshotListener {[weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let err = error {
                    debugPrint("Error fetching docs: \(err)")
                } else{
                    self.runs.removeAll()
                    self.runs = Running.parseData(snapshot: snapshot)
                    
                    self.dataSource = RegistroDataSource(running: self.runs)
                    self.tableView.dataSource = self.dataSource
                    self.dataSource.delegate = self
                    self.tableView.reloadData()
                }
            }
    }
    
    
}




//MARK: - UITableViewDelegate

extension RegistroVC : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        center(latitudine: runs[indexPath.row].latitude, longitudine: runs[indexPath.row].longitude, arrayUltimaCorsa: runs[indexPath.row].arrayPercorso)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1
      }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        5.0
//    }
    
}


//MARK: - RegistroDataSource

extension RegistroVC: RegistroDataSourceProtocol {
    
    func passAlert() {
        RunningAlert.errorLikes(on: self)
    }
    
    func dataForPrepareSegue(run: Running) {
        runningManager?.run = run
        mainCoordinator?.registroViewControllerDidPressededComments(self)
    }
}

//MARK: - CLLocationManagerDelegate

extension RegistroVC : CLLocationManagerDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if (overlay is MKPolyline){
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            polylineRender.strokeColor = #colorLiteral(red: 0.2745098039, green: 0.5490196078, blue: 0.9019607843, alpha: 1)
            polylineRender.lineWidth = 6
            return polylineRender
        }
        return MKOverlayRenderer()
    }
    
    func center(latitudine : Double, longitudine : Double, arrayUltimaCorsa : [GeoPoint]){
        var geoLoc = [CLLocationCoordinate2D]()
        geoLoc.removeAll()
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        let location = CLLocationCoordinate2D(latitude: latitudine, longitude: longitudine)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
        self.mapView.setRegion(region, animated: true)
        
        for i in arrayUltimaCorsa{
            geoLoc.append(CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude))
        }
        
        let aPolyline = MKPolyline(coordinates: geoLoc, count: geoLoc.count)
        self.mapView.addOverlay(aPolyline)
        tableView.reloadData()
    }
}

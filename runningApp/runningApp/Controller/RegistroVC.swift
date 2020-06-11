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




class RegistroVC: UIViewController, MKMapViewDelegate {
    
    
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    
    
    
    
    // Variables
    private var runListener : ListenerRegistration!
    private var runs = [Running]()
    private var datiDaPassare : Running?
    private var runCollectionRef: CollectionReference!
    private var handle : AuthStateDidChangeListenerHandle?
    private let regionMeter : Double = 1000
    private let locationManager = CLLocationManager()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function,"registro")
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        runCollectionRef = Firestore.firestore().collection(RUN_REFERENCE)
        setListener()
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
            print(#function,"registro")
       }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function,"registro")
        setListener()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setListener()
        tableView.reloadData()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if runListener != nil {
            runListener.remove()
        }
        
    }
    
    
    func refresh (){
        Firestore.firestore().collection(RUN_REFERENCE).getDocuments(completion: { (snapshot, error) in
            
            guard let snapshot = snapshot else { return debugPrint("Error fetching comments: \(error!)")}
            
            self.runs.removeAll()
            self.runs = Running.parseData(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
    
    
    func setListener(){
        runListener = runCollectionRef
            .order(by: REAL_DATA_RUNNING, descending: true)
            .addSnapshotListener { (snapshot, error) in
                if let err = error {
                    debugPrint("Error fetching docs: \(err)")
                } else{
                    self.runs.removeAll()
                    self.runs = Running.parseData(snapshot: snapshot)
                    self.tableView.reloadData()
                }
        }
    }
    
    
}

/*-------------------------------------------------------------------------*/




extension RegistroVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell()}
        
        datiDaPassare = nil
        
        cell.setCell(forCorsa: runs[indexPath.row])
        datiDaPassare = runs[indexPath.row]
        
        cell.delegate = self
        cell.delegateAlert = self
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        center(latitudine: runs[indexPath.row].latitude, longitudine: runs[indexPath.row].longitude, arrayUltimaCorsa: runs[indexPath.row].arrayPercorso)
    }
    
    
    
}



/*-----------------------------------------------------------------------------------------*/


extension RegistroVC: MyButtonDelegate{
    
    
    func opneCommentVC(for run: Running) {
        performSegue(withIdentifier: "segueToCommentVC", sender: run)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCommentVC"{
            if let destinationVC = segue.destination as? CommentsVC {
                if let run = sender as? Running{
                    destinationVC.run = run
                }
            }
        }
    }
    
    
    
}
/*-----------------------------------------------------------------------------------------*/

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
        var geo = [GeoPoint]()
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

    
extension RegistroVC : AlertDelegate{
    func likeTwice() {
        print("LIKE TWICE")
        RunningAlert.errorLikes(on: self)
    }
    
    
}


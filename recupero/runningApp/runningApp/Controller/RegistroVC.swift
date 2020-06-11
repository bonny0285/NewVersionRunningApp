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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    
    
    
    // Variables
    fileprivate var runListener : ListenerRegistration!
    
    fileprivate var runs = [Running]()
    fileprivate var run : Running!
    
    fileprivate var runCollectionRef: CollectionReference!
    fileprivate var handle : AuthStateDidChangeListenerHandle?
    fileprivate let regionMeter : Double = 1000
    fileprivate let locationManager = CLLocationManager()
    fileprivate var polylineLocation = [CLLocationCoordinate2D]()
    fileprivate var myIndexPath = 0
    fileprivate var myLatitudine = 0.0
    fileprivate var myLongitudine = 0.0
    fileprivate var myCoordinateTracks = [GeoPoint]()
    fileprivate var myTracks = [CLLocationCoordinate2D]()
    fileprivate var myRegion : CLLocationCoordinate2D?
    
    
    var lat = [0.0]
    var long = [0.0]
//    var geo = [GeoPoint]()
//    var geoLoc = [CLLocationCoordinate2D]()
    var count = 0
    //var run : Running?
    
    
    var aPolyline : MKPolyline?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setListener()
        tableView.delegate = self
        tableView.dataSource = self
//        collectionView.delegate = self
//        collectionView.dataSource = self
        mapView.delegate = self
        runCollectionRef = Firestore.firestore().collection(RUN_REFERENCE)
       // centerViewOnUserLocation()
        setListener()
        collectionView.reloadData()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setListener()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setListener()
        collectionView.reloadData()
        //centerViewOnUserLocation()
        
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
            self.collectionView.reloadData()
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
                    self.collectionView.reloadData()
                }
        }
    }
    
    
}

/*-----------------------------------------------------------------------------------------*/

//extension RegistroVC: UICollectionViewDelegate, UICollectionViewDataSource{
//    func empty(){
//        runs.removeAll()
//        refresh()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return runs.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        //empty()
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RECORDS_COLLECTION_CELL, for: indexPath) as? RecordsCollectionCell else { return UICollectionViewCell()}
//        let myIndex = runs[indexPath.row]
//        cell.setupCell(corsa: myIndex, mappa: center(latitudine: myIndex.latitude, longitudine: myIndex.longitude, arrayUltimaCorsa: myIndex.arrayPercorso))
////        let overlays = mapView.overlays
////        mapView.removeOverlays(overlays)
////        run = runs[indexPath.row]
//
////        center(latitudine: run.latitude, longitudine: run.longitude, arrayUltimaCorsa: run.arrayPercorso)
//        //refresh()
//        return cell
//    }
//
//
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.reloadData()
//        let overlays = mapView.overlays
//        mapView.removeOverlays(overlays)
//        run = runs[indexPath.row]
//        center(latitudine: run.latitude, longitudine: run.longitude, arrayUltimaCorsa: run.arrayPercorso)
//        performSegue(withIdentifier: "segueToCommentVC", sender: runs[indexPath.row])
//        print("CAZZO",runs[indexPath.row])
//    }
//
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////
////    }
//
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToCommentVC"{
//            if let destinationVC = segue.destination as? CommentsVC {
//                if let run = sender as? Running{
//                    destinationVC.run = run
//                    print("MIA RUN",run)
//                }
//            }
//        }
//    }
//
//}

/*-------------------------------------------------------------------------*/

extension RegistroVC : UITableViewDelegate,UITableViewDataSource{
    
    func empty(){
        runs.removeAll()
        refresh()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell()}
                let myIndex = runs[indexPath.row]
                cell.setupCell(corsa: myIndex, mappa: center(latitudine: myIndex.latitude, longitudine: myIndex.longitude, arrayUltimaCorsa: myIndex.arrayPercorso))
        //        let overlays = mapView.overlays
        //        mapView.removeOverlays(overlays)
        //        run = runs[indexPath.row]
                
        //        center(latitudine: run.latitude, longitudine: run.longitude, arrayUltimaCorsa: run.arrayPercorso)
                //refresh()
                return cell
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        run = runs[indexPath.row]
        center(latitudine: run.latitude, longitudine: run.longitude, arrayUltimaCorsa: run.arrayPercorso)
        performSegue(withIdentifier: "segueToCommentVC", sender: runs[indexPath.row])
        print("CAZZO",runs[indexPath.row])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCommentVC"{
            if let destinationVC = segue.destination as? CommentsVC {
                if let run = sender as? Running{
                    destinationVC.run = run
                    print("MIA RUN",run)
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
            polylineRender.strokeColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            polylineRender.lineWidth = 3
            return polylineRender
        }
        return MKOverlayRenderer()
    }
    
    
//    func centerViewOnUserLocation(){
//
//        let docRef = runCollectionRef
//        docRef?.order(by: REAL_DATA_RUNNING, descending: true).firestore.collectionGroup(RUN_REFERENCE).getDocuments(completion: { (snapshot, error) in
//            if let err = error{
//                debugPrint("Error fetching docs: \(err)")
//            } else {
//                self.runs.removeAll()
//                self.runs = Running.parseData(snapshot: snapshot)
//                print("docuemnto",self.runs)
//
//
//
//
//                for i in self.runs{
//                    self.run = i
//                    self.lat.append(self.run?.latitude ?? 0.0)
//                    self.long.append(self.run?.longitude ?? 0.0)
//                    self.geo = i.arrayPercorso
//                    self.count += 1
//                    print(i.arrayPercorso.count)
//                }
//
//                for i in self.geo{
//
//                    self.geoLoc.append(CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude))
//
//                }
//                print("geo", self.geoLoc)
//                let location = CLLocationCoordinate2D(latitude: self.lat.last ?? 0.0, longitude: self.long.last ?? 0.0)
//                print("locationnnn",location)
//                let region = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
//
//                self.mapView.setRegion(region, animated: true)
//
//                let aPolyline = MKPolyline(coordinates: self.geoLoc, count: self.geoLoc.count)
//                self.mapView.addOverlay(aPolyline)
//
//
//            }
//        })
//
//    }
    
    
    
    
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
        //collectionView.reloadData()
    }
    
}

    


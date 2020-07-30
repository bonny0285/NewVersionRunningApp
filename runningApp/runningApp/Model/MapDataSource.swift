//
//  MapDataSource.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 12/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase



protocol MapDataSourceProtocol: class {
    func addTotalKm(km: String)
    func addAvarageSpeed(speed: String)
}




class MapDataSource: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    var delegate: MapDataSourceProtocol?
    var map: MKMapView
    let locationManager = CLLocationManager()
    private let regionMeter : Double = 1000
    var polylineLocation = [CLLocationCoordinate2D]()
    var arrayGeo = [GeoPoint?]()
    var startLocation : CLLocation!
    var latitudine : Double = 0.0
    var longitude : Double = 0.0
    var runDistance = 0.0
    var lastLocation : CLLocation!
    var counter = 0
    var arrayKM = [Double]()
    var speedMax : Double = 0.0
    var isEndRun: Bool = true
    
    
    init(mapView: MKMapView) {
        self.map = mapView
        
       
    }
    
    func addDelegationOnMap(){
        map.delegate = self
        //locationManager.delegate = self
        checkLocationServices()
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorizzation()
        } else {
            #warning("show alert letting user know they have to turn this on")
        }
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func checkLocationAuthorizzation(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            #warning("show alert not allowed")
            break
        case .authorizedAlways:
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            #warning("show alert instruction them how to turn on permission")
            break
        @unknown default:
            fatalError()
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeter, longitudinalMeters: regionMeter)
            map.setRegion(region, animated: true)
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard let locationFirst = locations.first else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionMeter, longitudinalMeters: regionMeter)
        map.setRegion(region, animated: true)
        
        
   

        if isEndRun {
            
            latitudine = locationFirst.coordinate.latitude
            longitude = locationFirst.coordinate.longitude
            
            let inizio = CLLocationCoordinate2D(latitude: locationFirst.coordinate.latitude, longitude: locationFirst.coordinate.longitude)
            let fine = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            drawLine(startCoordinate: inizio,endingRun: fine)
            
            if startLocation == nil {
                startLocation = locations.first
            } else if let locations = locations.last {
                runDistance += lastLocation.distance(from: locations)
                
                delegate?.addTotalKm(km: "\(runDistance.metersToMiles(places: 3))")
                
                if counter > 0 && runDistance > 0 {
                    arrayKM.append(lastLocation.speed)
                    delegate?.addAvarageSpeed(speed: "\((lastLocation.speed * 3.6).twoDecimalNumbers(place: 1)) Km/h")
                    
                    speedMax = calcolaMediaKM(km: arrayKM)
                    
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
        arrayGeo.append(GeoPoint(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude))
        let aPolyline = MKPolyline(coordinates: polylineLocation, count: polylineLocation.count)
        self.map.addOverlay(aPolyline)
        
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

//
//  MapManager.swift
//  runningApp
//
//  Created by Massimiliano on 14/12/20.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseFirestore


/*
protocol MapDataSourceProtocol: class {
    func addTotalKm(km: String)
    func addAvarageSpeed(speed: String)
}
*/

class MapManager: NSObject {
    
    // MARK: - PROPERTIES
    
    var delegate: MapDataSourceProtocol?
    var map: MKMapView
    let locationManager = CLLocationManager()
    let regionMeter : Double = 1000
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
    var username: String
    
    private var getCoordinateCLLocationCoordinate2D: (Double, Double) -> (CLLocationCoordinate2D) = {lat, long in
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    private var speedAverage: ([Double]) -> Double = { km in
        var indice = 0
        var conta = 0.0
        for i in km {
            conta += i
            indice += 1
        }
        // var risultato = conta / Double(indice)
        //risultato = risultato * 3.6
        return (conta / Double(indice)) * 3.6
    }
    
    // MARK: - INITIALIZER
    
    init(mapView: MKMapView, username: String) {
        self.map = mapView
        self.username = username
        super.init()
        addDelegationOnMap()
    }
}

// MARK: - CLLocationManagerDelegate

extension MapManager: CLLocationManagerDelegate {
    
    func checkLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            #warning("show alert letting user know they have to turn this on")
            return
        }
        
        setupLocationManager()
        checkLocationAuthorizzation()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func checkLocationAuthorizzation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            #warning("show alert not allowed")
        case .authorizedAlways:
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            #warning("show alert instruction them how to turn on permission")
            break
        @unknown default:
            fatalError()
        }
    }
    
    func centerViewOnUserLocation() {
        guard let location = locationManager.location?.coordinate else { return }
        
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeter, longitudinalMeters: regionMeter)
        map.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last, let locationFirst = locations.first else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionMeter, longitudinalMeters: regionMeter)
        map.setRegion(region, animated: true)
        
        guard isEndRun else { return }
        
        latitudine = locationFirst.coordinate.latitude
        longitude = locationFirst.coordinate.longitude
        
        let inizio = getCoordinateCLLocationCoordinate2D(locationFirst.coordinate.latitude,locationFirst.coordinate.longitude)
        
        let fine = getCoordinateCLLocationCoordinate2D(location.coordinate.latitude, location.coordinate.latitude)
        
        drawLine(inizio,fine)
        
        if startLocation == nil {
            startLocation = locations.first
        } else if let locations = locations.last {
            runDistance += lastLocation.distance(from: locations)
            
            delegate?.addTotalKm(km: "\(runDistance.metersToMiles(places: 3))")
            
            guard counter > 0, runDistance > 0 else { return }
            
            arrayKM.append(lastLocation.speed)
            delegate?.addAvarageSpeed(speed: "\((lastLocation.speed * 3.6).twoDecimalNumbers(place: 1)) Km/h")
            
            speedMax = speedAverage(arrayKM)
            
        }
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizzation()
        centerViewOnUserLocation()
    }
}

// MARK: - MKMapViewDelegate

extension MapManager: MKMapViewDelegate {
    func addDelegationOnMap(){
        map.delegate = self
        //locationManager.delegate = self
        checkLocationServices()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKUserLocation else { return nil }
        
        let pin = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.pinTintColor = #colorLiteral(red: 0.2745098039, green: 0.5490196078, blue: 0.9019607843, alpha: 1)
        let label = UILabel()
        label.text = username
        label.textAlignment = .center
        pin.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: pin.topAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: pin.centerXAnchor).isActive = true
        return pin
    }
    
    func drawLine(_ startCoordinate : CLLocationCoordinate2D, _ endingRun : CLLocationCoordinate2D) {
        polylineLocation.append(startCoordinate)
        arrayGeo.append(GeoPoint(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude))
        let aPolyline = MKPolyline(coordinates: polylineLocation, count: polylineLocation.count)
        self.map.addOverlay(aPolyline)
        
    }
}

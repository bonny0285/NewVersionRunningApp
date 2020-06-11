//
//  Run.swift
//  runningApp
//
//  Created by Massimiliano on 07/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class Running {
    
    private(set) var dataRun : String
    private(set) var oraInizio : String
    private(set) var oraFine : String
    private(set) var tempoTotale : String
    private(set) var mediaVelocita : Double
    private(set) var totaleKm : Double
    private(set) var latitude : Double
    private(set) var longitude : Double
    private(set) var velocita : Double
    private(set) var arrayPercorso : [GeoPoint]
    private(set) var realTime : Timestamp
    private(set) var username : String
    private(set) var numComments : Int
    private(set) var documentID : String!
    private(set) var numLike : Int
     var userLike : [String]
    
    
    init(dataRun : String, oraInizio : String, oraFIne : String, tempoTotale : String, mediaVelocita : Double, totaleKm : Double, latitude : Double, longitude : Double, velocita : Double, arrayPercorso : [GeoPoint], realTime : Timestamp, username : String, numComments : Int, documentID : String, numLike : Int, userLike : [String]) {
        self.dataRun = dataRun
        self.oraInizio = oraInizio
        self.oraFine = oraFIne
        self.tempoTotale = tempoTotale
        self.totaleKm = totaleKm
        self.mediaVelocita = mediaVelocita
        self.latitude = latitude
        self.longitude = longitude
        self.velocita = velocita
        self.arrayPercorso = arrayPercorso
        self.realTime = realTime
        self.username = username
        self.numComments = numComments
        self.documentID = documentID
        self.numLike = numLike
        self.userLike = userLike
    }
    
    
    class func parseData(snapshot : QuerySnapshot?) -> [Running]{
        var run = [Running]()
        
        guard let snap = snapshot else { return run }
        for document in snap.documents{
            // print("DATAAAA",document.data())
            let data = document.data()
            let dataRun = data[DATA_RUNNING] as? String ?? " "
            //let dataRunTimestamp = dataRun.dateValue()
            let oraInizio = data[ORA_INIZIO] as? String ?? " "
            //let oraInizioTimestamp = oraInizio.dateValue()
            let oraFine = data[ORA_FINE] as? String ?? " "
            //let oraFineTimestamp = oraFine.dateValue()
            let tempoDiCorsa = data[TOTALE_TEMPO] as? String ?? " "
            let kmTotali = data[KM_TOTALI] as? Double ?? 0.0
            let mediaVelocita = data[SPEED_MAX] as? Double ?? 0.0
            let arrayPercorso = data[ARRAY_PERCORSO] as? [GeoPoint] ?? [GeoPoint(latitude: 00.0, longitude: 00.0)]
            let latitudine = data[LATITUDINE] as? Double ?? 0.0
            let longotudine = data[LONGITUDINE] as? Double ?? 0.0
            let realTime = data[REAL_DATA_RUNNING] as? Timestamp ?? Timestamp()
            let username = data[USERNAME] as? String ?? "Anonimus"
            let numComments = data[NUMBER_OF_COMMENTS] as? Int ?? 0
            let documentID = document.documentID
            let numLike = data[NUMBER_OF_LIKE] as? Int ?? 0
            let userLike = data[USER_LIKE] as? [String] ?? [" "]
            
            let newRun = Running(dataRun: dataRun, oraInizio: oraInizio, oraFIne: oraFine, tempoTotale: tempoDiCorsa, mediaVelocita: mediaVelocita, totaleKm: kmTotali, latitude: latitudine, longitude: longotudine, velocita: mediaVelocita, arrayPercorso: arrayPercorso, realTime: realTime, username: username, numComments: numComments, documentID: documentID, numLike: numLike, userLike: userLike)
            run.append(newRun)
        }
        return run
    }
    
    
}





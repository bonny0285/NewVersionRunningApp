//
//  FirebaseDataSource.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 11/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase

class FirebaseDataSource {
    
    static let shared = FirebaseDataSource()
    
    //MARK: - Login Function
    
    func loginWithMailAndPassword(withEmail email: String,password: String, completion:@escaping (AuthDataResult?,Error?) -> ()){
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }
    
    
    //MARK: - Create new User Function
    
    
    func createNewUser(withEmail email: String,password: String,username: String, completion: @escaping (AuthDataResult?,Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            completion(user,error)
        }
    }
    
    
    
    func saveDataOnFirebase (dataRunning: String,oraInizio: String, oraFine: String, kmTotali: Double,speedMax: Double, tempoTotale: String, arrayPercorso: [GeoPoint?], latitudine: Double, longitudine: Double,realDataRunning: Timestamp, username: String, numOfcomment: Int, numOfLike: Int, usersLikeit: [String]) {
        
        Firestore.firestore().collection(RUN_REFERENCE).addDocument(data: [
            DATA_RUNNING : dataRunning,
            ORA_INIZIO : oraInizio,
            ORA_FINE : oraFine,
            KM_TOTALI :kmTotali,
            SPEED_MAX :speedMax,
            TOTALE_TEMPO :tempoTotale,
            ARRAY_PERCORSO : arrayPercorso,
            LATITUDINE : latitudine,
            LONGITUDINE : longitudine,
            REAL_DATA_RUNNING : realDataRunning,
            USERNAME : username,
            NUMBER_OF_COMMENTS : numOfcomment,
            NUMBER_OF_LIKE : numOfLike,
            USER_LIKE : usersLikeit
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                //print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    
    
}


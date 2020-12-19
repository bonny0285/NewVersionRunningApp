//
//  FirebaseDataSource.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 11/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class FirebaseManager {
    
    let firestoreInstance = Firestore.firestore()
    let firestoreCollection = Firestore.firestore().collection(RUN_REFERENCE)
    
    //MARK: - Login & Create User
    
    /// Use this method for do a login access
    /// - Parameters:
    ///   - email: String
    ///   - password: String
    ///   - completion: @escaping (Result<AuthDataResult, Error>) -> Void
    func loginWithMailAndPassword(_ email: String, _ password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result))
            }
        }
    }
    
    /// Use this method for do a logout
    /// - Parameter completion: @escaping (Bool, Error?)
    /// - Returns: Void
    func logout(completion: @escaping (Result<Bool, Error>) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(.success(true))
        } catch let error {
            completion(.failure(error))
            debugPrint(error.localizedDescription)
        }
    }
    
    /// Use this method for create an user
    /// - Parameters:
    ///   - email: String
    ///   - password: String
    ///   - completion: @escaping (Result<AuthDataResult, Error>) -> Void
    func createUser(_ email: String, _ password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result))
            }
        }
    }
    
    //MARK: - Save Running Data
    
    /// Use this method for insert Running data in to Firebase
    /// - Parameters:
    ///   - dataRunning: String
    ///   - oraInizio: String
    ///   - oraFine: String
    ///   - kmTotali: Double
    ///   - speedMax: Double
    ///   - tempoTotale: String
    ///   - arrayPercorso: [GeoPoint?]
    ///   - latitudine: Double
    ///   - longitudine: Double
    ///   - realDataRunning: Timestamp
    ///   - username: String
    ///   - numOfcomment: Int
    ///   - numOfLike: Int
    ///   - usersLikeit: [String]
    func saveDataOnFirebase (dataRunning: String,oraInizio: String, oraFine: String, kmTotali: Double,speedMax: Double, tempoTotale: String, arrayPercorso: [GeoPoint?], latitudine: Double, longitudine: Double,realDataRunning: Timestamp, username: String, numOfcomment: Int, numOfLike: Int, usersLikeit: [String]) {
        
        firestoreCollection.addDocument(data: [
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
                debugPrint("Data added")
            }
        }
    }
    
    /// Use this method for retrive comment from FIrebase
    /// - Parameters:
    ///   - documentID: String
    ///   - completion: @escaping (Result<QuerySnapshot, Error>) -> Void
    func retriveComments(documentID: String, completion: @escaping (Result<QuerySnapshot, Error>) -> Void ) {
        firestoreCollection.document(documentID).collection(COMMENTS_REF).order(by: TIME_STAMP, descending: true).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                completion(.success(snapshot))
            }
        }
    }
    
    /// Use this method for save comment in to FIrebase
    /// - Parameters:
    ///   - documetID: String
    ///   - comments: String?
    ///   - username: String
    ///   - completion: @escaping (Result<Any,Error>) -> (Void))
    /// - Returns: Result<Any,Error>
    func addCommentToDataBase (documetID: String, comments: String?, username: String, completion: @escaping (Result<Any,Error>) -> ()) {
        var commentRef : DocumentReference!
        commentRef = firestoreCollection.document(documetID)
        
        firestoreCollection.document(documetID).collection(COMMENTS_REF).getDocuments { (snapshot, error) in
            guard let numeroCommenti = snapshot?.count else { return debugPrint("Error fetching comments: \(error!)") }
            
            guard let commentTxt = comments else { return }
            
            self.firestoreInstance.runTransaction({ (transaction, error) -> Any? in
                
                let thoughtDocument : DocumentSnapshot
                
                do {
                    try thoughtDocument = transaction.getDocument(self.firestoreCollection.document(documetID))
                } catch let error as NSError {
                    debugPrint("Fetch error: \(error.localizedDescription)")
                    return nil
                }
                
                guard (thoughtDocument.data()![NUMBER_OF_COMMENTS] as? Int) != nil else { return nil }
                
                transaction.updateData([NUMBER_OF_COMMENTS : numeroCommenti + 1], forDocument: commentRef!)
                
                let newCommentRef = self.firestoreCollection.document(documetID).collection(COMMENTS_REF).document()
                
                transaction.setData([
                    COMMENT_TXT : commentTxt,
                    TIME_STAMP : FieldValue.serverTimestamp(),
                    USERNAME : username
                ], forDocument: newCommentRef)
                
                return nil
            }) {(object, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let object = object {
                    completion(.success(object))
                }
            }
        }
    }
}

//class FirebaseDataSource {
//    
//    static let shared = FirebaseDataSource()
//    
//    //MARK: - Login Function
//    
//    func loginWithMailAndPassword(withEmail email: String,password: String, completion:@escaping (AuthDataResult?,Error?) -> ()){
//        
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            completion(user, error)
//        }
//    }
//    
//    
//    //MARK: - Create new User Function
//    
//    
//    func createNewUser(withEmail email: String,password: String,username: String, completion: @escaping (AuthDataResult?,Error?) -> ()) {
//        
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            completion(user,error)
//        }
//    }
//    
//    
//    
//    func saveDataOnFirebase (dataRunning: String,oraInizio: String, oraFine: String, kmTotali: Double,speedMax: Double, tempoTotale: String, arrayPercorso: [GeoPoint?], latitudine: Double, longitudine: Double,realDataRunning: Timestamp, username: String, numOfcomment: Int, numOfLike: Int, usersLikeit: [String]) {
//        
//        Firestore.firestore().collection(RUN_REFERENCE).addDocument(data: [
//            DATA_RUNNING : dataRunning,
//            ORA_INIZIO : oraInizio,
//            ORA_FINE : oraFine,
//            KM_TOTALI :kmTotali,
//            SPEED_MAX :speedMax,
//            TOTALE_TEMPO :tempoTotale,
//            ARRAY_PERCORSO : arrayPercorso,
//            LATITUDINE : latitudine,
//            LONGITUDINE : longitudine,
//            REAL_DATA_RUNNING : realDataRunning,
//            USERNAME : username,
//            NUMBER_OF_COMMENTS : numOfcomment,
//            NUMBER_OF_LIKE : numOfLike,
//            USER_LIKE : usersLikeit
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                debugPrint("Data added")
//            }
//        }
//    }
//    
//    
//    
//    func retriveComments(documentID: String, completion: @escaping (QuerySnapshot) -> (Void)) {
//        
//        Firestore.firestore().collection(RUN_REFERENCE).document(documentID).collection(COMMENTS_REF).order(by: TIME_STAMP, descending: true).getDocuments { (snapshot, error) in
//            
//            guard let snapshot = snapshot else { return debugPrint("Error fetching comments: \(error!)") }
//            completion(snapshot)
//        }
//    }
//    
//    
//    
//    func addCommentToDataBase (documetID: String, comments: String?, username: String, completion: @escaping(Any?,Error?) -> ()) {
//        var commentRef : DocumentReference!
//        commentRef = Firestore.firestore().collection(RUN_REFERENCE).document(documetID)
//        
//        
//        Firestore.firestore().collection(RUN_REFERENCE).document(documetID).collection(COMMENTS_REF).getDocuments { (snapshot, error) in
//            guard let numeroCommenti = snapshot?.count else { return debugPrint("Error fetching comments: \(error!)") }
//            
//            guard let commentTxt = comments else { return }
//            
//            Firestore.firestore().runTransaction({ (transaction, error) -> Any? in
//                
//                let thoughtDocument : DocumentSnapshot
//                
//                do {
//                    try thoughtDocument = transaction.getDocument(Firestore.firestore().collection(RUN_REFERENCE).document(documetID))
//                } catch let error as NSError {
//                    debugPrint("Fetch error: \(error.localizedDescription)")
//                    return nil
//                }
//                
//                guard (thoughtDocument.data()![NUMBER_OF_COMMENTS] as? Int) != nil else { return nil }
//                
//                transaction.updateData([NUMBER_OF_COMMENTS : numeroCommenti + 1], forDocument: commentRef!)
//                
//                let newCommentRef = Firestore.firestore().collection(RUN_REFERENCE).document(documetID).collection(COMMENTS_REF).document()
//                
//                transaction.setData([
//                    COMMENT_TXT : commentTxt,
//                    TIME_STAMP : FieldValue.serverTimestamp(),
//                    USERNAME : username
//                ], forDocument: newCommentRef)
//                
//                return nil
//            }) {(object, error) in
//                completion(object,error)
//            }
//            
//        }
//    }
//    
//    
//    
//}


//
//  TableViewCell.swift
//  runningApp
//
//  Created by Massimiliano on 17/10/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class TableViewCell: UITableViewCell {

    @IBOutlet var viewBackground: UIView!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var inizioCorsaLbl: UILabel!
    @IBOutlet var fineCorsaLbl: UILabel!
    @IBOutlet var tempoTotaleLbl: UILabel!
    @IBOutlet var dataGiornoLbl: UILabel!
    @IBOutlet var percorsoTotaleLbl: UILabel!
    @IBOutlet var mediaVelocitaLbl: UILabel!
    @IBOutlet var commentsLbl: UILabel!
    @IBOutlet var numLike: UILabel!
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var commentsBtn: UIButton!
    
    
    
    private var run : Running!
    var tapGesture = UITapGestureRecognizer()
    var username : String!
    let vc : RegistroVC! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.layer.cornerRadius = 15
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        //commentsBtn.addGestureRecognizer(tapGesture)
        //commentsBtn.isUserInteractionEnabled = true
          likeImage.addGestureRecognizer(tapGesture)
          likeImage.isUserInteractionEnabled = true
    }

    
    @objc func likeTapped(_ sender: UITapGestureRecognizer){
        // Method 1
        print("HELLOOOOOOO")
        var runListener : ListenerRegistration!
        var runCollectionRef: CollectionReference!
        runCollectionRef = Firestore.firestore().collection(RUN_REFERENCE)
        
        username = Auth.auth().currentUser?.displayName! ?? ""
        Firestore.firestore().collection(RUN_REFERENCE).document(run.documentID).getDocument { (snapshot, error) in
            if let error = error {
                debugPrint("Error fetching docs: \(error)")
            } else {
                let data = snapshot?.data()
                self.findUserLike(data: data!, userName: self.username)
            }
        }
    }

   
    
    func findUserLike (data : [String : Any], userName : String) -> Bool{
        var myBool : Bool?
        for i in data{
            if i.key == "userLike"{
                myBool = true
                userSearch(userLike: [i.key : i.value], user: userName)
                //print("trovato, cerchiamo se contiene il nostro user", myBool!)
                break
            } else {
                myBool = false
                Firestore.firestore().collection(RUN_REFERENCE).document(run.documentID).updateData([USER_LIKE : [username]])
                print("nessun userlike, dobbiamo creare USER_LIKE", myBool!)
            }
        }
        return myBool!
    }
    
    
    func userSearch (userLike : [String : Any], user : String){
        var service : Any?
        var myUser = user
        var myBool = true
        var userLiked : Bool?
        for i in userLike {
            if i.key == "userLike"{
                service = i.value
                print(service!)
                for i in service as! [String] {
                    var a = i
                    if a == user {
                        print("HAI GIA MESSO MI PIACE")
                        print("non incremntare il contatore")
                        userLiked = true
                        break
                    } else {
                        myBool = false
                        userLiked = false
                    }
                }
                if myBool == false && userLiked == false{
                    print("COMPLIMENTI HAI MESSO MI PIACE !!!")
                    print("incrementa il contatore e aggiungi il nome all'array")
                    
                    run.userLike.append(user)
                    Firestore.firestore().collection(RUN_REFERENCE).document(run.documentID).setData([NUMBER_OF_LIKE : self.run.numLike + 1, USER_LIKE : self.run.userLike], merge: true)
                } else {
                    break
                }
            } else {
                print("CE UN ERRORE")
            }
        }
    }
    
    
    
    func setupCell(corsa : Running, mappa : ()){
        run = corsa
        let a = Firestore.firestore().collection(RUN_REFERENCE).document(run.documentID).collection(COMMENTS_REF).order(by: REAL_DATA_RUNNING, descending: true).getDocuments { (snapshot, error) in
            guard let numeroCommenti = snapshot?.count else { return debugPrint("Error fetching comments: \(error!)") }
           
            self.dataGiornoLbl.text = "\(self.run.dataRun)"
            self.inizioCorsaLbl.text = "\(self.run.oraInizio)"
            self.fineCorsaLbl.text = "\(self.run.oraFine)"
            self.tempoTotaleLbl.text = "\(self.run.tempoTotale)"
            self.mediaVelocitaLbl.text = "\((self.run.mediaVelocita).twoDecimalNumbers(place: 1))"
            //percorsoTotaleLbl.text = "\(run.totaleKm.twoDecimalNumbers(place: 1))"
            self.percorsoTotaleLbl.text = "\((self.run.totaleKm).twoDecimalNumbers(place: 3))"
            self.usernameLbl.text = "Username: \(self.run.username)"
            //self.commentsLbl.text = "\(self.run.numComments)"
            self.commentsLbl.text = "\(numeroCommenti)"
            self.numLike.text = "\(self.run.userLike.count)"
            
        }
        
    }
    
    
    
    
    
    
    

}

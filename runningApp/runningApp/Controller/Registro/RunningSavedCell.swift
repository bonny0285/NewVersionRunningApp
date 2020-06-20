//
//  RunningSavedCell.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 19/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol ButtonDelegate: class {
    func commentButtonWasPressed(for run: Running)
}


protocol AlertLikeDelegate: class {
    func likeTwice()
}


class RunningSavedCell: UITableViewCell {

    @IBOutlet weak var sfondo: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dataGiornoLabel: UILabel!
    @IBOutlet weak var inizioCorsaLabel: UILabel!
    @IBOutlet weak var fineCorsaLabel: UILabel!
    @IBOutlet weak var tempoTotaleLabel: UILabel!
    @IBOutlet weak var percorsoTotaleLabel: UILabel!
    @IBOutlet weak var mediaVelocitàLabel: UILabel!
    @IBOutlet weak var numCommentLabel: UILabel!
    @IBOutlet weak var numLIkeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    
    //MARK: - Properties
    private var run: Running!
    var myRun: Running!
    var username: String!
    var buttonDelegate: ButtonDelegate?
    var alertDelegate: AlertLikeDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        SetupUIElement.shared.setupUIElement(element: sfondo)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func commonInit() {
        addSubview(sfondo)
        
        sfondo.frame = self.bounds
        sfondo.translatesAutoresizingMaskIntoConstraints = false
        //sfondo.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sfondo.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        sfondo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        //sfondo.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sfondo.leadingAnchor.constraint(equalTo:  leadingAnchor).isActive = true
        sfondo.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        contentView.backgroundColor = .clear
    }
    
    
    func userSearch (userLike : [String : Any], user : String){
        var service : Any?
        //var myUser = user
        var myBool = true
        var userLiked : Bool?
        for i in userLike {
            if i.key == "userLike"{
                service = i.value
                print(service!)
                for i in service as! [String] {
                    let a = i
                    if a == user {
                        alertDelegate?.likeTwice()
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
    
    
    
    
    func findUserLike (data : [String : Any], userName : String) {
        //var myBool : Bool?
        for i in data{
            if i.key == "userLike"{
                //myBool = true
                userSearch(userLike: [i.key : i.value], user: userName)
                //print("trovato, cerchiamo se contiene il nostro user", myBool!)
                break
            } else {
               // myBool = false
                Firestore.firestore().collection(RUN_REFERENCE).document(myRun.documentID).updateData([USER_LIKE : [username]])
                print("nessun userlike, dobbiamo creare USER_LIKE")
            }
        }
       // return myBool!
    }
    
    

   
    
    @IBAction func likeButtonWasPressed(_ sender: UIButton) {
//        var runListener : ListenerRegistration!
//        var runCollectionRef: CollectionReference!
//        runCollectionRef = Firestore.firestore().collection(RUN_REFERENCE)
        
        username = Auth.auth().currentUser?.displayName! ?? ""
        Firestore.firestore().collection(RUN_REFERENCE).document(myRun.documentID).getDocument { (snapshot, error) in
            if let error = error {
                debugPrint("Error fetching docs: \(error)")
            } else {
                let data = snapshot?.data()
                self.findUserLike(data: data!, userName: self.username)
            }
        }
    }
    
    @IBAction func commentButtonWasPressed(_ sender: UIButton) {
        buttonDelegate?.commentButtonWasPressed(for: myRun)
    }
    
    
}

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
        sfondo.setupRunningView()
        //SetupUIElement.shared.setupUIElement(element: sfondo)
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
        var userLiked : Bool?
        userLike.forEach { key, value in
            if key == "userLike" {
                let service = value as! [String]
                service.forEach {
                    if $0 == user {
                        alertDelegate?.likeTwice()
                        debugPrint("HAI GIA MESSO MI PIACE")
                        debugPrint("non incremntare il contatore")
                        userLiked = true
                        return
                    } else {
                        userLiked = false
                    }
                }
                if userLiked == false {
                    debugPrint("COMPLIMENTI HAI MESSO MI PIACE !!!")
                    debugPrint("incrementa il contatore e aggiungi il nome all'array")
                    
                    run.userLike.append(user)
                    Firestore.firestore().collection(RUN_REFERENCE).document(run.documentID).setData([NUMBER_OF_LIKE : self.run.numLike + 1, USER_LIKE : self.run.userLike], merge: true)
                } else {
                    return
                }
            } else {
                debugPrint("CE UN ERRORE")
            }
        }
    }
    
    
    
    
    func findUserLike (data : [String : Any], userName : String) {
        for i in data{
            if i.key == "userLike"{
                userSearch(userLike: [i.key : i.value], user: userName)
                debugPrint("trovato, cerchiamo se contiene il nostro user")
                break
            } else {
                Firestore.firestore().collection(RUN_REFERENCE).document(myRun.documentID).updateData([USER_LIKE : [username]])
                print("nessun userlike, dobbiamo creare USER_LIKE")
            }
        }
    }
    
    

   
    
    @IBAction func likeButtonWasPressed(_ sender: UIButton) {
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

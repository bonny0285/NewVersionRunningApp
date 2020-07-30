////
////  TableViewCell.swift
////  runningApp
////
////  Created by Massimiliano on 17/10/2019.
////  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
////
//
//import UIKit
//import MapKit
//import Firebase
//
//
//protocol MyButtonDelegate {
//    func opneCommentVC(for run : Running)
//}
//
//
//protocol AlertDelegate{
//    func likeTwice()
//}
//
//
//class TableViewCell: UITableViewCell {
//    
//    @IBOutlet var viewBackground: UIView!
//    @IBOutlet var usernameLbl: UILabel!
//    @IBOutlet var inizioCorsaLbl: UILabel!
//    @IBOutlet var fineCorsaLbl: UILabel!
//    @IBOutlet var tempoTotaleLbl: UILabel!
//    @IBOutlet var dataGiornoLbl: UILabel!
//    @IBOutlet var percorsoTotaleLbl: UILabel!
//    @IBOutlet var mediaVelocitaLbl: UILabel!
//    @IBOutlet var commentsLbl: UILabel!
//    @IBOutlet var numLike: UILabel!
//    @IBOutlet var likeImage: UIImageView!
//    @IBOutlet var commentsBtn: UIButton!
//    
//    
//    
//    private var run : Running!
//    var myRun : Running!
//    var tapGesture = UITapGestureRecognizer()
//    var username : String!
//    let vc : RegistroVC! = nil
//    var delegate : MyButtonDelegate?
//    var delegateAlert : AlertDelegate?
//    
//    
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        SetupUIElement.shared.setupUIElement(element: viewBackground)
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTapped(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        tapGesture.numberOfTouchesRequired = 1
//        
//        likeImage.addGestureRecognizer(tapGesture)
//        likeImage.isUserInteractionEnabled = true
//    }
//    
//    
//    @objc func likeTapped(_ sender: UITapGestureRecognizer){
//
//        username = Auth.auth().currentUser?.displayName! ?? ""
//        Firestore.firestore().collection(RUN_REFERENCE).document(myRun.documentID).getDocument { (snapshot, error) in
//            if let error = error {
//                debugPrint("Error fetching docs: \(error)")
//            } else {
//                let data = snapshot?.data()
//                self.findUserLike(data: data!, userName: self.username)
//            }
//        }
//    }
//    
//    
//    
//    func findUserLike (data : [String : Any], userName : String) {
//        
//        for dict in data{
//            if dict.key == "userLike" {
//                userSearch(userLike: [dict.key : dict.value], user: userName)
//                break
//            } else {
//                Firestore.firestore().collection(RUN_REFERENCE).document(myRun.documentID).updateData([USER_LIKE : [username]])
//                debugPrint("nessun userlike, dobbiamo creare USER_LIKE")
//            }
//        }
//    }
//    
//    
//    func userSearch (userLike : [String : Any], user : String){
//        //var service : Any?
//        var myBool = true
//        var userLiked : Bool?
//        userLike.forEach { key, value in
//            if key == "userLike" {
//                let service = value as! [String]
//                service.forEach {
//                    if $0 == user {
//                        delegateAlert?.likeTwice()
//                        debugPrint("HAI GIA MESSO MI PIACE")
//                        debugPrint("non incremntare il contatore")
//                        userLiked = true
//                        return
//                    } else {
//                        myBool = false
//                        userLiked = false
//                    }
//                }
//                if userLiked == false {
//                    debugPrint("COMPLIMENTI HAI MESSO MI PIACE !!!")
//                    debugPrint("incrementa il contatore e aggiungi il nome all'array")
//                    
//                    run.userLike.append(user)
//                    Firestore.firestore().collection(RUN_REFERENCE).document(run.documentID).setData([NUMBER_OF_LIKE : self.run.numLike + 1, USER_LIKE : self.run.userLike], merge: true)
//                } else {
//                    return
//                }
//            } else {
//                debugPrint("CE UN ERRORE")
//            }
//        }
////        for i in userLike {
////            if i.key == "userLike"{
////                service = i.value
////                debugPrint(service!)
////                for i in service as! [String] {
////                    let a = i
////                    if a == user {
////                        delegateAlert?.likeTwice()
////                        debugPrint("HAI GIA MESSO MI PIACE")
////                        debugPrint("non incremntare il contatore")
////                        userLiked = true
////                        break
////                    } else {
////                        myBool = false
////                        userLiked = false
////                    }
////                }
////                if myBool == false && userLiked == false{
////                    debugPrint("COMPLIMENTI HAI MESSO MI PIACE !!!")
////                    debugPrint("incrementa il contatore e aggiungi il nome all'array")
////
////                    run.userLike.append(user)
////                    Firestore.firestore().collection(RUN_REFERENCE).document(run.documentID).setData([NUMBER_OF_LIKE : self.run.numLike + 1, USER_LIKE : self.run.userLike], merge: true)
////                } else {
////                    break
////                }
////            } else {
////                debugPrint("CE UN ERRORE")
////            }
////        }
//    }
//
//    
//    
//    @IBAction func commentBtnWasPressed(_ sender: Any) {
//        delegate?.opneCommentVC(for: myRun)
//    }
//    
//    
//    
//    
//}

//
//  CommentsVC.swift
//  runningApp
//
//  Created by Massimiliano on 16/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommentsVC: UIViewController, UITableViewDelegate, MainCoordinated, RunningManaged {

    
    
    
    
    //MARK: - Outlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var keyboardView: UIView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var commentTxt: UITextField!
    
    
    
    //MARK: - Properties

    // var commentListener : ListenerRegistration!
    var firebaseManager: FirebaseManager?
    private var commentRef : DocumentReference! {
        firestore.collection(RUN_REFERENCE).document(run.documentID)
    }
    private let firestore = Firestore.firestore()
    var run : Running! {
        runningManager?.run
    }
    private var comments = [Comment]()
    private var username : String! {
        Auth.auth().currentUser?.displayName
    }
    var dataSource: CommentDataSource!
    var mainCoordinator: MainCoordinator?
    
    var runningManager: RunningManager?
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseManager = FirebaseManager()
        tableView.delegate = self
        //commentRef = firestore.collection(RUN_REFERENCE).document(run.documentID)
        
//        if let name = Auth.auth().currentUser?.displayName {
//            username = name
//        }
        
        self.view.bindToKeyboard()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
       refreshCommentList()
    }
    
    
    func refreshCommentList () {
        firebaseManager?.retriveComments(documentID: run.documentID, completion: { [weak self] (snapshot, error) -> (Void) in
            guard let self = self else { return }
            
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.dataSource = CommentDataSource(comments: self.comments)
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        })
//        FirebaseDataSource.shared.retriveComments(documentID: self.run.documentID) { [weak self] (snapshot) -> (Void) in
//            guard let self = self else { return }
//
//            self.comments.removeAll()
//            self.comments = Comment.parseData(snapshot: snapshot)
//            self.dataSource = CommentDataSource(comments: self.comments)
//            self.tableView.dataSource = self.dataSource
//            self.tableView.reloadData()
//        }
    }

    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addBtnWasPressed(_ sender: Any) {
        AddNewComment()
    }
    
    

    
    
    func AddNewComment (){
        
        firebaseManager?.addCommentToDataBase(documetID: run.documentID, comments: commentTxt.text, username: username, completion: { [weak self] (object, error) in
            guard let self = self else { return }
            
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                self.commentTxt.text = ""
                self.commentTxt.resignFirstResponder()
                self.refreshCommentList()
            }
        })
        
//        FirebaseDataSource.shared.addCommentToDataBase(documetID: run.documentID, comments: commentTxt.text, username: username) { [weak self] object, error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                debugPrint("Transaction failed: \(error)")
//            } else {
//                self.commentTxt.text = ""
//                self.commentTxt.resignFirstResponder()
//                self.refreshCommentList()
//            }
//        }
    }
    
    
}


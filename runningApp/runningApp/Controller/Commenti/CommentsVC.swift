//
//  CommentsVC.swift
//  runningApp
//
//  Created by Massimiliano on 16/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController, UITableViewDelegate {
    
    
    
    //MARK: - Outlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var keyboardView: UIView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var commentTxt: UITextField!
    
    
    
    //MARK: - Properties

    // var commentListener : ListenerRegistration!
    private var commentRef : DocumentReference!
    private let firestore = Firestore.firestore()
    var run : Running!
    private var comments = [Comment]()
    private var username : String!
    var dataSource: CommentDataSource!
    
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        commentRef = firestore.collection(RUN_REFERENCE).document(run.documentID)
        
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
        
        self.view.bindToKeyboard()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
       refreshCommentList()
    }
    
    
    func refreshCommentList () {
        FirebaseDataSource.shared.retriveComments(documentID: self.run.documentID) { (snapshot) -> (Void) in
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.dataSource = CommentDataSource(comments: self.comments)
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }

    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addBtnWasPressed(_ sender: Any) {
        AddNewComment()
    }
    
    

    
    
    func AddNewComment (){
        FirebaseDataSource.shared.addCommentToDataBase(documetID: run.documentID, comments: commentTxt.text, username: username) { object, error in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.commentTxt.text = ""
                self.commentTxt.resignFirstResponder()
                self.refreshCommentList()
            }
        }
    }
    
    
}


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
        aggiungiCommento()
    }
    
    
    func aggiungiCommento () {
        firestore.collection(RUN_REFERENCE).document(self.run.documentID).collection(COMMENTS_REF).getDocuments(completion: { (snapshot, error) in
            guard let numeroCommenti = snapshot?.count else { return debugPrint("Error fetching comments: \(error!)") }
            
            guard let commentTxt = self.commentTxt.text else { return }
            
            self.firestore.runTransaction({ (transaction, error) -> Any? in
                
                let thoughtDocument : DocumentSnapshot
                
                
                do {
                    try thoughtDocument = transaction.getDocument(Firestore.firestore().collection(RUN_REFERENCE).document(self.run.documentID))
                } catch let error as NSError {
                    debugPrint("Fetch error: \(error.localizedDescription)")
                    return nil
                }
                
                guard (thoughtDocument.data()![NUMBER_OF_COMMENTS] as? Int) != nil else { return nil }
                
                
                
                transaction.updateData([NUMBER_OF_COMMENTS : numeroCommenti + 1], forDocument: self.commentRef!)
                
                let newCommentRef = self.firestore.collection(RUN_REFERENCE).document(self.run.documentID).collection(COMMENTS_REF).document()
                
                
                transaction.setData([
                    COMMENT_TXT : commentTxt,
                    TIME_STAMP : FieldValue.serverTimestamp(),
                    USERNAME : self.username!
                ], forDocument: newCommentRef)
                
                return nil
            }) { (object, errro) in
                if let error = errro{
                    debugPrint("Transaction failed: \(error)")
                } else {
                    self.commentTxt.text = ""
                    self.commentTxt.resignFirstResponder()
                    self.refreshCommentList()
                  
                }
            }
            self.view.endEditing(true)
            
        })
    }
    
    
    func AddNewDocument (){
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


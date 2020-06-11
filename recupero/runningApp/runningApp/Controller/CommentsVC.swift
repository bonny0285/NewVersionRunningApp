//
//  CommentsVC.swift
//  runningApp
//
//  Created by Massimiliano on 16/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController {

    
    
    // Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var keyboardView: UIView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var commentTxt: UITextField!
    
    
    
    // Variables
    var commentListener : ListenerRegistration!
    var commentRef : DocumentReference!
    let firestore = Firestore.firestore()
    var run : Running!
    private var comments = [Comment]()
    private var corsa = [Running]()
    var username : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        commentRef = firestore.collection(RUN_REFERENCE).document(run.documentID)
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
        self.view.bindToKeyboard()
        
        print("NUMERO COMMENTI",comments.count)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    
    func refresh (){
        let a = firestore.collection(RUN_REFERENCE).document(run.documentID).collection(COMMENTS_REF).order(by: TIME_STAMP, descending: true).getDocuments(completion: { (snapshot, error) in
            guard let snapshot = snapshot else { return debugPrint("Error fetching comments: \(error!)")}
            
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //commentListener.remove()
        
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func addBtnWasPressed(_ sender: Any) {
        interazioneBottone()
    }
    
    
    func interazioneBottone () {
        let realNum = self.firestore.collection(RUN_REFERENCE).document(self.run.documentID).collection(COMMENTS_REF).getDocuments(completion: { (snapshot, error) in
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
                
                guard let oldNumComments = thoughtDocument.data()![NUMBER_OF_COMMENTS] as? Int else { return nil }
                
                
                
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
                    self.refresh()
                }
            }
            self.view.endEditing(true)
            
        })
    }
    
    

}



extension CommentsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as? CommentsCell else { return UITableViewCell() }
        cell.configureCell(comment: comments[indexPath.row])
        return cell
    }
    
    
}

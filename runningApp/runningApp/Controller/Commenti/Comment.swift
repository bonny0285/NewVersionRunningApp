//
//  Comment.swift
//  Firebase_Project
//
//  Created by Massimiliano on 05/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase

class Comment {
    
    private(set) var username : String!
    private(set) var timeStamp : Date!
    private(set) var commentTxt : String!
    
    
    
    init(username : String, timeStamp : Date, commentTxt : String) {
        
        self.username = username
        self.timeStamp = timeStamp
        self.commentTxt = commentTxt
    }
    
    
    
    
    
    class func parseData(snapshot : QuerySnapshot?) -> [Comment]{
        var comments = [Comment]()
        guard let snap = snapshot else { return comments }
        for document in snap.documents{
            // print("DATAAAA",document.data())
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            let time = data[TIME_STAMP] as? Timestamp ?? Timestamp()
            let timeStamp = time.dateValue()
            let commentTxt = data[COMMENT_TXT] as? String ?? ""
        
            let newComment = Comment(username: username, timeStamp: timeStamp, commentTxt: commentTxt)
            comments.append(newComment)
        }
        return comments
    }
}

//
//  CommentDelegate.swift
//  runningApp
//
//  Created by Massimiliano Bonafede on 12/06/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit


class CommentDataSource: NSObject {
    
    var organizer: DataOrganizer
    
    init(comments: [Comment]) {
        self.organizer = DataOrganizer(comments: comments)
    }
    
}


extension CommentDataSource {
    
    struct DataOrganizer {
        
        private var comments: [Comment]
        var commentsCount: Int
        
        init(comments: [Comment]) {
            self.comments = comments
            self.commentsCount = comments.count
        }
        
        
        func getComment (at index: IndexPath) -> Comment {
            comments[index.row]
        }
    }
}


extension CommentDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        organizer.commentsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.commentsCell, for: indexPath) else { return UITableViewCell() }
        
        let row = organizer.getComment(at: indexPath)
        cell.configureRow(at: row)
        
        return cell
    }
}




extension CommentsCell {
    
    func configureRow (at comment: Comment) {
        usernameLbl.text = comment.username
        commentsLbl.text = comment.commentTxt
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, hh:mm"
        let timeStamp = formatter.string(from: (comment.timeStamp)!)
        dateLbl.text = timeStamp
    }
}

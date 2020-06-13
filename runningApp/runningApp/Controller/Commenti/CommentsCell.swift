//
//  CommentsCell.swift
//  runningApp
//
//  Created by Massimiliano on 16/07/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Firebase

class CommentsCell: UITableViewCell {

    
    //MARK: - Outlets

    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var commentsLbl: UILabel!
   
    private var comments = [Comment]()
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    


    
    
    func configureCell(comment : Comment){
        usernameLbl.text = comment.username
        //timeStampTxt.text = comment.timeStamp
        commentsLbl.text = comment.commentTxt
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, hh:mm"
        let timeStamp = formatter.string(from: (comment.timeStamp)!)
        dateLbl.text = timeStamp
    }

}

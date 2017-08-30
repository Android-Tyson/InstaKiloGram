//
//  PostCell.swift
//  InstaKiloGram
//
//  Created by Tyson  on 8/29/17.
//  Copyright © 2017 HistoryMakers. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post){
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
    }
}

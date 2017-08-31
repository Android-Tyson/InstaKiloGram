//
//  PostCell.swift
//  InstaKiloGram
//
//  Created by Tyson  on 8/29/17.
//  Copyright © 2017 HistoryMakers. All rights reserved.
//

import UIKit
import Firebase

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
    
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil{
            self.postImg.image = img
        }else{
            
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data,error) in
                if error != nil{
                    print("Tyson: Unable to download images from firebase")
                }else{
                    print("Tyson: downloaded images from firebase")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                            
                        }
                    }
                }
            })
            
        
        }
    }
}











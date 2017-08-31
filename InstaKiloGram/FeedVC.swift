//
//  FeedVC.swift
//  InstaKiloGram
//
//  Created by Tyson  on 8/28/17.
//  Copyright © 2017 HistoryMakers. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var captionField: FancyField!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString,UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            
             self.posts = [] //clear the array each time loaded to reduce duplicity
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    print("Snap: \(snap)")
                    if let postDict = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let post = posts[indexPath.row]
       
        //reuse the cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
                cell.configureCell(post: post, img: img)
            }else{
                cell.configureCell(post: post)
            }
            return cell
            
        }else{
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageAdd.image = image
            imageSelected = true
        }else{
            print("Tyson : invalid image")
        }
        //dismiss after image being selected
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        //check caption is empty or not
        guard let caption = captionField.text, caption != "" else{
            print("Tyson: Caption must be entered")
            return
        }
        //check image is empty or not
        guard let img = imageAdd.image , imageSelected == true else {
            print("Tyson: Image must be added")
            return
        }
        //conversion of image compression
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            //assigning unique id
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata){(metadata,error) in
                if error != nil{
                    print("Tyson: Unable to upload images to firebase")
                }else{
                    print("Tyson: Successfully uploaded images to firebase")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url =  downloadUrl{
                        self.postToFirebase(imgUrl: url)
                    }
                    
                    
                    
                }
            }
            
        }
        
        
    }
    
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String, AnyObject> = [
        "caption": captionField.text as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        //add unique id to post
        let firebasePost =  DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
            
        
    }
    @IBAction func addImageTapped(_ sender: Any) {
        
        //presenting the image picker
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func signOutTapped(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Tyson: Keychain removed for id: \(keyChainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "gotoSignIn", sender: nil)
    }
}

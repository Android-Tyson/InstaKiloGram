//
//  SignInVC.swift
//  InstaKiloGram
//
//  Created by Tyson  on 8/28/17.
//  Copyright © 2017 HistoryMakers. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "gotoFeed", sender: nil)
        }
    }
    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("Tyson: Unable to authenticate with facebook \(error!)")
            }else if result?.isCancelled == true{
                print("Tyson: User cancelled facebook")
            }else{
                print("Tyson: User successfully authenticated.")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential, completion: {(user,error) in
            if error != nil{
                print("Tyson: Unable to authenticate with facebook \(error!)")
            }else {
                print("Tyson: Successfully authenticated facebook")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text , let pwd = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil{
                    print("Tyson: Email user authenticate with firebase")
                    if let user = user{
                        self.completeSignIn(id: user.uid)
                    }
                }else{
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("Tyson: Unable to authenticate with firebase using email \(error!)")
                        }else{
                            print("Tyson: successfylly authenticated with firebase using email")
                            if let user = user{
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String ){
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Tyson: Data saved to keychain : \(keychainResult)")
        performSegue(withIdentifier: "gotoFeed", sender: nil)
    }
}









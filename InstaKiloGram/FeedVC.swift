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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signOutTapped(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Tyson: Keychain removed for id: \(keyChainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "gotoSignIn", sender: nil)
    }
}

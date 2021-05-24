//
//  UserHomeViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class UserHomeViewController: UserTabViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedSignInButton(_ sender: UIButton) {
        self.presentSignInViewController()
    }
    

}

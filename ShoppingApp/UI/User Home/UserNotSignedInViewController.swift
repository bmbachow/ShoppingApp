//
//  UserHomeViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class UserNotSignedInViewController: UserTabViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func tappedSignInButton(_ sender: UIButton) {
        self.presentSignInViewController()
    }
    @IBAction func tappedSignUpButton(_ sender: Any) {
        self.presentSignUpViewController()
    }
    
}

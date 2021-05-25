//
//  UserHomeViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//

import UIKit

class UserHomeViewController: UserTabViewController {
    
    private let userNotSignedInViewController = UserNotSignedInViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(userNotSignedInViewController)
        self.view.addSubview(userNotSignedInViewController.view)
        NSLayoutConstraint.activate([
            userNotSignedInViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            userNotSignedInViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            userNotSignedInViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            userNotSignedInViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNotSignedInViewController.view.isHidden = self.user != nil
    }
    
    override func userChanged() {
        super.userChanged()
        self.userNotSignedInViewController.view.isHidden = self.user != nil
    }
}

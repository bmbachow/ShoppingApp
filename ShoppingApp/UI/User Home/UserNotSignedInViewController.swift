//
//  UserHomeViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class UserNotSignedInViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource {
    var bcColor = UIView()
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var imageData = ["shoppingimg","wishlistimg","reviewimg"]
    private var textData = ["Shop with us and get the best deals on the market!","Add items to your wishlist for later purchases!","Create a review for your favorite products!"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "UserNotSignInTableViewCell", bundle: nil), forCellReuseIdentifier: "UserNotSignInTableViewCell")
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier:  "UserNotSignInTableViewCell") as! UserNotSignInTableViewCell
        cell.img.image = UIImage(named: imageData[indexPath.row])
        cell.label.text = textData[indexPath.row]
        cell.backgroundColor = .clear
        bcColor.backgroundColor = .systemGray5
        cell.selectedBackgroundView = bcColor
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

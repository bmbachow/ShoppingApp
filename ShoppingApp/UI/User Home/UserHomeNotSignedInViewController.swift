//
//  UserHomeNotSignedInViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class UserHomeNotSignedInViewController: UserHomeViewController, UITableViewDelegate, UITableViewDataSource {
    var bcColor = UIView()
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet override weak var tableView: UITableView! {
        get {
            return super.tableView
        } set {
            super.tableView = newValue
        }
    }
    
    private var imageData = ["shoppingimg","wishlistimg","reviewimg"]
    private var textData = ["Shop with us and get the best deals on the market!","Add items to your wishlist for later purchases!","Create a review for your favorite products!"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "UserNotSignInTableViewCell", bundle: nil), forCellReuseIdentifier: "UserNotSignInTableViewCell")
        self.tableView.register(UINib(nibName: "ProductsCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersCollectionTableViewCell")
        self.tableView.register(UINib(nibName: "ProductsCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "WishListCollectionTableViewCell")
        
        
        self.setUpCollectionViews()
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
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier:  "UserNotSignInTableViewCell") as! UserNotSignInTableViewCell
            cell.img.image = UIImage(named: imageData[indexPath.row])
            cell.label.text = textData[indexPath.row]
            cell.backgroundColor = .clear
            bcColor.backgroundColor = .systemGray5
            cell.selectedBackgroundView = bcColor
            return cell
        default:
            return self.wishListCollectionTableViewCell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return imageData.count
        default:
            return self.user?.wishListProductsArray.count == 0 ? 0 : 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//
//  UserHomeSignedInViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//

import UIKit

class UserHomeSignedInViewController: UserHomeViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet override weak var tableView: UITableView! {
        get {
            return super.tableView
        } set {
            super.tableView = newValue
        }
    }
    
    weak var signOutButton: UIButton!
    
    private let userNotSignedInViewController = UserHomeNotSignedInViewController()
    
    private var shouldHideUserNotSignedInViewController: Bool {
        return self.user != nil && !(self.user is AnonymousUser)
    }
    
    private var memberSinceString: String {
        guard let user = self.user else { return "Member since ?" }
        guard let registeredDate = user.registeredDate else { return "Member since ?" }
        return "Member since " + DateFormatter.standardDate.string(from: registeredDate)
    }
    
    lazy private var userHomeMainTableViewCell: UserHomeMainTableViewCell = {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserHomeMainTableViewCell") as? UserHomeMainTableViewCell else {
            fatalError("Unable to dequeue UserHomeMainTableViewCell")
        }
        return cell
    }()
    
    lazy private var userHomeStuffCell: UserHomeStuffCell = {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserHomeStuffCell") as? UserHomeStuffCell else {
            fatalError("Unable to dequeue UserHomeStuffCell")
        }
        self.signOutButton = cell.signOutButton
        cell.signOutButton.addTarget(self, action: #selector(self.tappedSignOutButton(_:)), for: .touchUpInside)
        return cell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addChild(userNotSignedInViewController)
        self.view.addSubview(userNotSignedInViewController.view)
        self.tableView.register(UINib(nibName: "UserHomeMainTableViewCell", bundle: nil), forCellReuseIdentifier: "UserHomeMainTableViewCell")
        self.tableView.register(UINib(nibName: "ProductsCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersCollectionTableViewCell")
        self.tableView.register(UINib(nibName: "ProductsCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "WishListCollectionTableViewCell")
        self.tableView.register(UINib(nibName: "UserHomeStuffCell", bundle: nil), forCellReuseIdentifier: "UserHomeStuffCell")
        
        // this must be called after tableView is set up
        self.setUpCollectionViews()
        
        NSLayoutConstraint.activate([
            userNotSignedInViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            userNotSignedInViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            userNotSignedInViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            userNotSignedInViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshUserNotSignedInVisibility()
    }
    
    override func userChanged(_ notification: Notification) {
        super.userChanged(notification)
        guard notification.object as? UserTabViewController != self else { return }
        self.refreshData()
    }
    
    func refreshUserNotSignedInVisibility() {
            self.userNotSignedInViewController.view.isHidden = self.shouldHideUserNotSignedInViewController
    }
    
    func refreshData() {
        guard self.tableView != nil else { return }
        self.userHomeMainTableViewCell.nameLabel.text = (user?.firstName ?? "") + " " + (user?.lastName ?? "")
        self.userHomeMainTableViewCell.memberSinceLabel.text = self.memberSinceString
        self.userHomeMainTableViewCell.profileImageView.image = self.user?.image ?? UIImage(systemName: "person.circle.fill")!
        self.refreshGiftCardBalance()
        self.tableView.reloadData()
        self.ordersCollectionView.reloadData()
        self.refreshUserNotSignedInVisibility()
        self.refreshWishList()
    }
    
    override func cartChanged(_ notification: Notification) {
        super.cartChanged(notification)
    }
    
    override func wishListChanged(_ notification: Notification) {
        super.wishListChanged(notification)
        guard notification.object as? UserTabViewController != self else { return }
        self.refreshWishList()
    }
    
    override func giftCardBalanceChanged(_ notification: Notification) {
        super.giftCardBalanceChanged(notification)
        guard notification.object as? UserTabViewController != self else { return }
        self.refreshGiftCardBalance()
    }
    
    func refreshWishList() {
        self.wishListCollectionView.reloadData()
    }
    
    func refreshGiftCardBalance() {
        self.userHomeStuffCell.balanceLabel.text = NumberFormatter.dollars.string(from: self.user?.giftCardBalance ?? 0)
    }

    @objc func tappedSignOutButton(_ sender: UIButton){
        if let uuid = UIDevice.current.identifierForVendor {
            self.remoteAPI.getAnonymousUserOrCreateIfNotExists(
                uuid: uuid,
                success: { anonymousUser in
                    self.user = anonymousUser
                    self.presentSignInViewController()
                }, failure: { error in
                    print(error.localizedDescription)
                })
        }
    }
    
    
    
    
    
    
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.userHomeMainTableViewCell
        case 1:
            switch indexPath.row {
            case 0:
                return self.ordersCollectionTableViewCell
            default:
                return self.wishListCollectionTableViewCell
            }
        default:
            return self.userHomeStuffCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 1
        }
        
    }

}

//
//  UserHomeViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//

import UIKit

class UserHomeViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var ordersCollectionView: UICollectionView!
    
    weak var ordersButton: UIButton!
    
    weak var wishListButton: UIButton!
    
    weak var wishListCollectionView: UICollectionView!
    
    private let userNotSignedInViewController = UserNotSignedInViewController()
    
    private var shouldHideUserNotSignedInViewController: Bool {
        return self.user != nil
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
    
    lazy private var ordersCollectionTableViewCell: ProductsCollectionTableViewCell = {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrdersCollectionTableViewCell") as? ProductsCollectionTableViewCell else {
            fatalError("Unable to dequeue ProductsCollectionTableViewCell")
        }
        self.ordersButton = cell.button
        cell.button.addTarget(self, action: #selector(self.tappedOrdersButton(_:)), for: .touchUpInside)
        cell.button.setTitle("Orders", for: .normal)
        self.ordersCollectionView = cell.collectionView
        self.ordersCollectionView.delegate = self
        self.ordersCollectionView.dataSource = self
        return cell
    }()
    
    lazy private var wishListCollectionTableViewCell: ProductsCollectionTableViewCell = {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "WishListCollectionTableViewCell") as? ProductsCollectionTableViewCell else {
            fatalError("Unable to dequeue ProductsCollectionTableViewCell")
        }
        self.wishListButton = cell.button
        cell.button.addTarget(self, action: #selector(self.tappedWishListButton(_:)), for: .touchUpInside)
        cell.button.setTitle("Wish List", for: .normal)
        self.wishListCollectionView = cell.collectionView
        self.wishListCollectionView.delegate = self
        self.wishListCollectionView.dataSource = self
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
        let _ = self.ordersCollectionTableViewCell
        let _ = self.wishListCollectionTableViewCell
        self.ordersCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        self.wishListCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
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
        self.userNotSignedInViewController.view.isHidden = self.shouldHideUserNotSignedInViewController
    }
    
    override func userChanged() {
        guard self.tableView != nil else { return }
        super.userChanged()
        self.refreshData()
        self.userNotSignedInViewController.view.isHidden = self.shouldHideUserNotSignedInViewController
    }
    
    func refreshData() {
        guard self.tableView != nil else { return }
        self.userHomeMainTableViewCell.nameLabel.text = (user?.firstName ?? "") + " " + (user?.lastName ?? "")
        self.userHomeMainTableViewCell.memberSinceLabel.text = self.memberSinceString
        self.userHomeMainTableViewCell.profileImageView.image = self.user?.image ?? UIImage(systemName: "person.circle.fill")!
        self.tableView.reloadData()
        self.ordersCollectionView.reloadData()
        self.wishListCollectionView.reloadData()
    }
    
    override func cartChanged() {
        super.cartChanged()
        self.refreshData()
    }
    
    override func wishListChanged() {
        super.wishListChanged()
        self.refreshData()
    }
    
    
    
    
    
    
    
    @objc func tappedOrdersButton(_ sender: UIButton){
        let vc = OrdersListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tappedWishListButton(_ sender: UIButton){
        let vc = WishListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    
    
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.userHomeMainTableViewCell
        default:
            switch indexPath.row {
            case 0:
                return self.ordersCollectionTableViewCell
            default:
                return self.wishListCollectionTableViewCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 2
        }
        
    }
    
    //MARK: UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.ordersCollectionView {
            return self.user?.ordersArray.count ?? 0
        } else {
            return self.user?.wishListProductsArray.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.ordersCollectionView {
            var images = [UIImage]()
            if let cartItemsArray = self.user?.ordersArray[indexPath.row].cartItemsArray {
                for cartItem in cartItemsArray {
                    if let image = cartItem.product?.image {
                        images += [image]
                    }
                }
            }
            guard let cell = self.wishListCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
                fatalError("Unable to dequeue ProductCollectionViewCell")
            }
            cell.imageGridView.setImages(images)
            return cell
        } else {
            let product = self.user?.wishListProductsArray[indexPath.row]
            guard let cell = self.wishListCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
                fatalError("Unable to dequeue ProductCollectionViewCell")
            }
            if let image = product?.image {
                cell.imageGridView.setImages([image])
            }
            return cell
        }
    }
}

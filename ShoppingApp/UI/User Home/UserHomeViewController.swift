//
//  UserViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/3/21.
//

import UIKit

class UserHomeViewController: UserTabViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var tableView: UITableView!

    var ordersCollectionView: UICollectionView!
    
    var wishListCollectionView: UICollectionView!
    
    weak var ordersButton: UIButton!
    
    weak var wishListButton: UIButton!
    
    lazy var ordersCollectionTableViewCell: ProductsCollectionTableViewCell = {
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
    
    lazy var wishListCollectionTableViewCell: ProductsCollectionTableViewCell = {
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
    
    }
    
    // this class must be subclassed with an
    // actual tableView set or this will crash
    
    // call this in subclass's viewDidLoad
    // after setting up the tableView
    func setUpCollectionViews() {
        let _ = self.ordersCollectionTableViewCell
        let _ = self.wishListCollectionTableViewCell
        self.ordersCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        self.wishListCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
    
    
    
    @objc func tappedOrdersButton(_ sender: UIButton){
        let vc = OrdersListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tappedWishListButton(_ sender: UIButton){
        let vc = WishListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func wishListChanged(_ notification: Notification) {
        super.wishListChanged(notification)
        guard notification.object as? UserTabViewController != self else { return }
        self.refreshWishList()
    }
    
    override func ordersChanged(_ notification: Notification) {
        super.ordersChanged(notification)
        guard notification.object as? UserTabViewController != self else { return }
        self.refreshOrders()
    }
    
    func refreshWishList() {
        self.tableView?.reloadData()
        self.wishListCollectionView?.reloadData()
    }
    
    func refreshOrders() {
        self.tableView?.reloadData()
        self.ordersCollectionView?.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.ordersCollectionView {
            guard let order = self.user?.ordersArray[indexPath.row] else { return }
            self.goToOrderDetail(order: order, remoteAPI: self.remoteAPI)
        } else {
            guard let product = self.user?.wishListProductsArray[indexPath.row] else { return }
            self.goToProductDetail(product: product)
        }
    }
}

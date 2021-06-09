//
//  WishListViewController.swift
//  ShoppingApp
//
//  Created by Brian Bachow on 5/27/21.
//

import UIKit

class WishListViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource, WishListTableViewCellDelegate {
    
    
    @IBOutlet weak var wishListTable: UITableView!
        
    var wishListItems: [Product] {
        return self.user?.wishListProductsArray ?? []
    }
    
    override var shouldShowEmptyPromptView: Bool {
        self.wishListItems.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wishListTable.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "WishListTableViewCell")
        self.wishListTable.delegate = self
        self.wishListTable.dataSource = self
        let footerView = UIView()
        footerView.backgroundColor = .white
        self.wishListTable.tableFooterView = footerView
        self.navigationItem.title = "Wish List"
        (self.navigationController as? BazaarNavigationController)?.setLogoVisibile(false)
        
        self.emptyPromptView.setUp(image: UIImage(named: "wishlistimg")!, labelText: "Your wish list is empty...", buttonTitle: "Continue shopping")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tappedEmptyPromptButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = self.wishListItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WishListTableViewCell") as? WishListTableViewCell else {
            fatalError("Unable to dequeue WishListTableViewCell")
        }
        cell.delegate = self
        cell.productImageView.image = product.image
        cell.nameLabel.text = product.name
        cell.priceLabel.text =  NumberFormatter.dollars.string(from: product.price)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tappedAddToCartButton(inCell cell: WishListTableViewCell) {
        guard let indexPath = wishListTable.indexPath(for: cell) else {
            return
        }
        self.addProductToCart(self.wishListItems[indexPath.row])
    }
    
    func tappedDeleteButton(inCell cell: WishListTableViewCell) {
        guard let indexPath = wishListTable.indexPath(for: cell) else {
            return
        }
        
        wishListTable.beginUpdates()
        
        remoteAPI.deleteProductFromWishList(product: self.wishListItems[indexPath.row], user: self.user!, success: {
            wishListTable.deleteRows(at: [indexPath], with: .right)
            self.updateEmptyPromptViewVisibility(animated: true, completion: nil)
            wishListTable.endUpdates()
            Notifications.postWishListChanged(fromViewController: self)
        }, failure: { error in
            print(error.localizedDescription)
            wishListTable.endUpdates()
        })
    }
    
    override func wishListChanged(_ notification: Notification) {
        super.wishListChanged(notification)
        guard notification.object as? UserTabViewController != self else { return }
        self.updateEmptyPromptViewVisibility(animated: false, completion: nil)
        self.wishListTable.reloadData()
    }

}

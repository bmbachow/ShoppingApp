//
//  WishListViewController.swift
//  ShoppingApp
//
//  Created by Brian Bachow on 5/27/21.
//

import UIKit

class WishListViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource, WishListTableViewCellDelegate {
    
    
    @IBOutlet weak var wishListTable: UITableView!
        
    var wishListItems: [Product]{
        return self.user?.wishListProductsArray ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wishListTable.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "WishListTableViewCell")
        self.wishListTable.delegate = self
        self.wishListTable.dataSource = self
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tappedAddToCartButton(inCell cell: WishListTableViewCell) {
       
    }
    
    func tappedDeleteButton(inCell cell: WishListTableViewCell) {
        guard let indexPath = wishListTable.indexPath(for: cell) else {
            return
        }
        
        wishListTable.beginUpdates()
        
        remoteAPI.deleteProductFromWishList(product: self.wishListItems[indexPath.row], user: self.user!, success: {
            wishListTable.deleteRows(at: [indexPath], with: .right)
            wishListTable.endUpdates()
        }, failure: { error in
            print(error.localizedDescription)
            wishListTable.endUpdates()
        })
    }
    
    override func wishListChanged() {
        super.wishListChanged()
        self.wishListTable.reloadData()
    }

}

//
//  CartViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class CartViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cartProducts: [Product] {
        return self.user?.cartProductsArray ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CartProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CartProductTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = self.cartProducts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductTableViewCell") as? CartProductTableViewCell else {
            fatalError("Unable to dequeue CartProductTableViewCell")
        }
        cell.productImageView.image = product.image
        cell.nameLabel.text = product.name
        cell.priceLabel.text = NumberFormatter.dollars.string(from: Float(product.price))
        return cell
    }
}

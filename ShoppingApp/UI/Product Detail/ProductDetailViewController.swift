//
//  ProductDetailViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/24/21.
//

import UIKit

class ProductDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    var user: User?
    
    let product: Product
    
    lazy var productDetailMainTableViewCell: ProductDetailMainTableViewCell = {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductDetailMainTableViewCell") as? ProductDetailMainTableViewCell else {
            fatalError("Unable to dequeue ProductDetailMainTableViewCell")
        }
        return cell
    }()
    
    init(user: User?, product: Product) {
        self.user = user
        self.product = product
        super.init(nibName: "ProductDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProductDetailMainTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailMainTableViewCell")
        self.productDetailMainTableViewCell.productNameLabel.text = self.product.name
        self.productDetailMainTableViewCell.productImageView.image = self.product.image
        self.productDetailMainTableViewCell.productPriceLabel.text = NumberFormatter.dollars.string(from: Float(self.product.price))
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.productDetailMainTableViewCell
    }
}

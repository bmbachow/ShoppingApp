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
        self.tableView.register((UINib(nibName: "ProductDetailReviewTableViewCell", bundle: nil)), forCellReuseIdentifier: "ProductDetailReviewTableViewCell")
        self.productDetailMainTableViewCell.productNameLabel.text = self.product.name
        self.productDetailMainTableViewCell.productImageView.image = self.product.image
        self.productDetailMainTableViewCell.productPriceLabel.text = NumberFormatter.dollars.string(from: Float(self.product.price))
        self.productDetailMainTableViewCell.cosmosView.rating = self.product.averageRating ?? 0
    }

    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        default:
            return self.product.reviewsArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.productDetailMainTableViewCell
        default:
            let review = self.product.reviewsArray[indexPath.row]
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductDetailReviewTableViewCell") as? ProductDetailReviewTableViewCell else {
                fatalError("Unable to dequeue ProductDetailReviewTableViewCell")
            }
            cell.usernameTextView.text = review.user?.firstName ?? "Anonymous"
            cell.cosmosView.rating = Double(review.rating)
            if let postedDate = review.postedDate {
                cell.reviewDateTextView.text = "Reviewed on " + DateFormatter.standardDate.string(from: postedDate) + " at " + DateFormatter.standardTime.string(from: postedDate)
            }
            cell.titleTextView.text = review.title
            cell.bodyTextView.text = review.body
            return cell
        }
    }
}

//
//  ProductDetailViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/24/21.
//

import UIKit

class ProductDetailViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

      
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    weak var addToCartButton: UIButton!
    
    weak var addToWishListButton: UIButton!
    
    weak var writeAReviewButton: UIButton!
    
    weak var relatedItemsCollectionView: UICollectionView!
    
    var relatedProductsArray = [Product]()
    
    let product: Product
    
    lazy private var productDetailMainTableViewCell: ProductDetailMainTableViewCell = {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductDetailMainTableViewCell") as? ProductDetailMainTableViewCell else {
            fatalError("Unable to dequeue ProductDetailMainTableViewCell")
        }
        self.addToCartButton = cell.addToCartButton
        cell.addToCartButton.addTarget(self, action: #selector(self.tappedAddToCartButton), for: .touchUpInside)
        self.addToWishListButton = cell.addToWishListButton
        cell.addToWishListButton.addTarget(self, action: #selector(self.tappedAddToWishListButton), for: .touchUpInside)
        return cell
    }()
    
    lazy private var productCollectionTableViewCell:
        ProductsCollectionTableViewCell = {
            guard let cell =
                    self.tableView.dequeueReusableCell(withIdentifier: "ProductsCollectionTableViewCell") as? ProductsCollectionTableViewCell else {
                fatalError("Unable to dequeue ProductsCollectionTableViewCell")
            }
            self.relatedItemsCollectionView = cell.collectionView
            cell.button.setTitle("Check these out", for: .normal)
            return cell
        }()
    
    lazy var productDetailReviewHeaderTableViewCell:
        ProductDetailReviewHeaderTableViewCell = {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductDetailReviewHeaderTableViewCell") as? ProductDetailReviewHeaderTableViewCell else {
                fatalError("ProductDetailReviewHeaderTableViewCell")
            }
            self.writeAReviewButton = cell.writeAReviewButton
            cell.writeAReviewButton.addTarget(self, action: #selector(self.tappedWriteAReviewButton), for: .touchUpInside)
            cell.hideSeparator(tableViewWidth: self.tableView.frame.width)
            return cell
        }()
    
    init(product: Product) {
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
        self.tableView.register((UINib(nibName: "ProductsCollectionTableViewCell", bundle: nil)),
            forCellReuseIdentifier: "ProductsCollectionTableViewCell")
        self.tableView.register(UINib(nibName: "ProductDetailReviewHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailReviewHeaderTableViewCell")

        let _ = self.productCollectionTableViewCell
        self.relatedItemsCollectionView.register((UINib(nibName: "ProductCollectionViewCell", bundle: nil)),
            forCellWithReuseIdentifier: "ProductCollectionViewCell")
        self.relatedItemsCollectionView.delegate = self
        self.relatedItemsCollectionView.dataSource = self
        self.productDetailMainTableViewCell.productNameLabel.text = self.product.name
        self.productDetailMainTableViewCell.productImageView.image = self.product.image
        self.productDetailMainTableViewCell.productPriceLabel.text = NumberFormatter.dollars.string(from: Float(self.product.price))
        self.productDetailMainTableViewCell.cosmosView.rating = self.product.averageRating ?? 0
        self.remoteAPI.getProducts(searchString: nil, category: self.product.category, success: { products in
            self.relatedProductsArray = products.filter({$0.name != self.product.name})
            self.tableView.reloadData()
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    @objc func tappedAddToCartButton(_ sender: UIButton) {
        self.addProductToCart()
    }
    
    @objc func tappedAddToWishListButton(_ sender: UIButton) {
        self.addProductToWishList()
    }
    
    @objc func tappedWriteAReviewButton(_ sender: UIButton) {
        self.presentNewReviewViewController()
    }
    
    func addProductToCart() {
        if let user = self.user {
            self.remoteAPI.addProductToCart(product: self.product, user: user, success: {
                self.userTabBarController?.cartChanged(fromViewController: self)
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
    }
    
    func addProductToWishList() {
        if let user = self.user {
            self.remoteAPI.addProductToWishList(product: self.product, user: user, success: {
                self.userTabBarController?.wishListChanged(fromViewController: self)
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
    }
    
    func presentNewReviewViewController() {
        let viewController = NewReviewViewController()
        self.present(viewController, animated: true)
    }
    
   

    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return self.product.reviewsArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.productDetailMainTableViewCell
        case 1:
            return self.productCollectionTableViewCell
        case 2:
            return self.productDetailReviewHeaderTableViewCell
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
            cell.hideSeparator(tableViewWidth: self.tableView.frame.width)
            return cell
        }
    }
    
    // MARK: UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        relatedProductsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.relatedItemsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
            fatalError("Unable to dequeue product collection view cell")
        }
        let product = relatedProductsArray[indexPath.row]
        if let image = product.image {
            cell.imageGridView.setImages([image])
        }
        return cell
    }
}

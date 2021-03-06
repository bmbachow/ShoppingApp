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
    
    var productReviewsArray = [ProductReview]()
    
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
            cell.button.isUserInteractionEnabled = false
            cell.button.setTitleColor(.black, for: .normal)
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
        self.refreshProductReviewsArray()

        (self.navigationController as? BazaarNavigationController)?.setLogoVisibile(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func tappedAddToCartButton(_ sender: UIButton) {
        self.addProductToCart(self.product)
    }
    
    @objc func tappedAddToWishListButton(_ sender: UIButton) {
        self.addProductToWishList(self.product)
    }
    
    @objc func tappedWriteAReviewButton(_ sender: UIButton) {
        guard self.user != nil, !(self.user is AnonymousUser) else {
            return self.presentNotSignedInAlert()
        }
        self.attemptPresentNewReviewViewController()
    }
    
    func attemptPresentNewReviewViewController() {
        var onDismiss: () -> Void = {}
        if let review = self.product.reviewsArray.first(where: {$0.user == user}){
            self.presentAlertWithActions(title: "You've already reviewed this product", message: "Would you like to edit your existing review or replace it with a new one?", actions: [
                (title: "Edit", handler: {
                    onDismiss = { [weak self] in
                        self?.presentNewReviewViewController(existingReviewTask: .edit(review))
                    }
                } ),
                (title: "Replace", handler: {
                    onDismiss = { [weak self] in
                        self?.presentNewReviewViewController(existingReviewTask: .replace(review))
                    }
                }),
                (title: "Cancel", handler: {
                    
                })
            ], onDismiss: {onDismiss()})
        } else {
            self.presentNewReviewViewController(existingReviewTask: nil)
        }
    }
    
    func presentNewReviewViewController(existingReviewTask: NewReviewViewController.ExistingReviewTask?) {
        guard let user = self.user else { return }
        let viewController = NewReviewViewController(user: user, product: self.product, existingReviewTask: existingReviewTask, reviewSubmittedAction: { [weak self] in
            self?.refreshProductReviewsArray()
            self?.dismiss(animated: true, completion: nil)
        })
        self.present(viewController, animated: true)
    }
    
    func refreshProductReviewsArray() {
        self.productReviewsArray = product.reviewsArray.sorted(by: {
            let date = Date()
            return $0.postedDate ?? date > $1.postedDate ?? date
        })
        self.tableView.reloadData()
    }
    
    override func profilePhotoChanged(_ notification: Notification) {
        super.profilePhotoChanged(notification)
        guard let user = self.user else { return }
        guard self.tableView != nil else { return }
        guard let indexPaths = self.tableView.indexPathsForVisibleRows?
                .filter({$0.section == 3 &&
                    self.productReviewsArray[$0.row].user == user
                }) else {
            return
        }
        for indexPath in indexPaths {
            guard let cell = self.tableView.cellForRow(at: indexPath) as? ProductDetailReviewTableViewCell else {
                continue
            }
            cell.userImageView.image = user.image
        }
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
            return self.productReviewsArray.count
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
            let review = self.productReviewsArray[indexPath.row]
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
            if let image = review.user?.image {
                cell.userImageView.image = image
            } else {
                cell.userImageView.image = UIImage(systemName: "person.crop.circle.fill")
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.goToProductDetail(product: self.relatedProductsArray[indexPath.row])
    }
}

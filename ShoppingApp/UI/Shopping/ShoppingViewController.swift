//
//  ShoppingViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class ShoppingViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    private var shouldShowSignInViewControllerOnAppear = true
    
    private var products = [Product]()
    
    private var categories = [Category]()
    
    private var selectedCategory: Category?
    
    lazy var adCell : ShoppingAdTableViewCell = {
        return self.tableView.dequeueReusableCell(withIdentifier: "ShoppingAdTableViewCell") as! ShoppingAdTableViewCell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ShoppingAdTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingAdTableViewCell")
        self.tableView.register(UINib(nibName: "ShoppingProductPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingProductPreviewTableViewCell")
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize (width: 200, height: 120)
//        collectionView.collectionViewLayout = layout
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: "MyCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
      
        self.remoteAPI.getAllProducts(success: { products in
            self.products = products
            self.tableView.reloadData()
        }, failure: { error in
            print(error.localizedDescription)
        })

        self.remoteAPI.getAllCategories(success: { categories in
            self.categories = categories
            self.collectionView.reloadData()
        }, failure: { error in
            print(error.localizedDescription)
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adCell.startAdTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.shouldShowSignInViewControllerOnAppear {
            self.presentSignInViewController()
            self.shouldShowSignInViewControllerOnAppear = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.adCell.invalidateTimer()
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.products.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.adCell
        default:
            let product = self.products[indexPath.row]
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ShoppingProductPreviewTableViewCell") as! ShoppingProductPreviewTableViewCell
            cell.productName.text = product.name
            cell.productImage.image = product.image
            cell.productPrice.text = NumberFormatter.dollars.string(from: Float(product.price))
            cell.productRating.rating = product.averageRating ?? 0
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        default:
            let viewController = ProductDetailViewController(product: self.products[indexPath.row])
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension ShoppingViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("you tapped me")
    }
    
}

extension ShoppingViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        let buttonText: String
        switch indexPath.section {
        case 0:
            buttonText = "All"
        default:
            buttonText = self.categories[indexPath.row].name ?? "?"
            
        }
        cell.configure(buttonText: buttonText)
        cell.delegate = self
        return cell
        
    }
}

extension ShoppingViewController : MyCollectionViewCellDelegate{
    
    func tappedCategoryButton(in cell: MyCollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else {
            return
        }
        switch indexPath.section {
        case 0:
            self.selectedCategory = nil
        default:
            self.selectedCategory = self.categories[indexPath.row]
        }
    }
}

extension ShoppingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.text else { return }
        self.remoteAPI.getProducts(searchString: searchString, category: self.selectedCategory, success: { products in
            self.products = products
            self.tableView.reloadData()
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}

//
//extension ShoppingViewController: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    }
//
//}
//



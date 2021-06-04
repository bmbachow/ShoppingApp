//
//  ShoppingViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import UIKit

class ShoppingViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource, SearchHistoryTableViewCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchHistoryTableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    private var shouldShowSignInViewControllerOnAppear = true
    
    private var shouldHideSearchHistoryTableView: Bool {
        !self.searchBar.isFirstResponder
    }
    
    private var products = [Product]()
    
    private var categories = [Category]()
    
    private var searchHistory: [String] {
        self.user?.searchHistory ?? []
    }
    
    //private var selectedCategory: Category?
    
    lazy var adCell : ShoppingAdTableViewCell = {
        return self.tableView.dequeueReusableCell(withIdentifier: "ShoppingAdTableViewCell") as! ShoppingAdTableViewCell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchHistoryTableView.delegate = self
        self.searchHistoryTableView.dataSource = self
        self.tableView.register(UINib(nibName: "ShoppingAdTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingAdTableViewCell")
        self.tableView.register(UINib(nibName: "ShoppingProductPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingProductPreviewTableViewCell")
        self.searchHistoryTableView.register(UINib(nibName: "SearchHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchHistoryTableViewCell")
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
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adCell.startAdTimer()
        self.refreshSearchHistoryTableViewVisibility()
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
    
    func refreshSearchHistoryTableViewVisibility() {
        self.searchHistoryTableView?.isHidden = self.shouldHideSearchHistoryTableView
    }
    
    override func userChanged() {
        super.userChanged()
        self.tableView?.reloadData()
        self.searchHistoryTableView?.reloadData()
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            switch section {
            case 0:
                return 1
            default:
                return self.products.count
            }
        } else {
            return self.searchHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
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
        } else {
            guard let cell = self.searchHistoryTableView.dequeueReusableCell(withIdentifier: "SearchHistoryTableViewCell") as? SearchHistoryTableViewCell else {
                fatalError("Unable to dequeue SearchHistoryTableViewCell")
            }
            cell.label.text = self.searchHistory[indexPath.row]
            cell.delegate = self
            return cell
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == self.tableView ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            switch indexPath.section {
            case 0:
                return
            default:
                guard let cell = self.tableView.cellForRow(at: indexPath) as? BaseTableViewCell else {
                    fatalError("Unable to get reference to cell")
                }
                cell.showSelection(true, animated: true, completion: {
                    self.goToProductDetail(product: self.products[indexPath.row])
                })
            }
        } else {
            let text = self.searchHistory[indexPath.row]
            self.searchBar.text = text
            self.searchFromSearchBarText()
        }
    }
    
    func scrollToTop() {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    //MARK: SearchHistoryTableViewCellDelegate
    
    func tappedXButton(inCell cell: SearchHistoryTableViewCell) {
        guard let indexPath = self.searchHistoryTableView.indexPath(for: cell) else {
            return
        }
        self.searchHistoryTableView.beginUpdates()
        let count = self.searchHistory.count
        guard let user = self.user else { return }
        self.remoteAPI.removeFromSearchHistory(user: user, searchString: self.searchHistory[indexPath.row], success: {
            if self.searchHistory.count == count - 1 {
                self.searchHistoryTableView.deleteRows(at: [indexPath], with: .top)
            } else {
                self.searchHistoryTableView.reloadData()
            }
            self.searchHistoryTableView.endUpdates()
        }, failure: { error in
            self.searchHistoryTableView.endUpdates()
            print(error.localizedDescription)
        })
   
    }
}

//MARK: UICollectionView

extension ShoppingViewController: UICollectionViewDelegate {
    
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

extension ShoppingViewController : MyCollectionViewCellDelegate {
    
    func tappedCategoryButton(in cell: MyCollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else {
            return
        }
        let selectedCategory: Category?
        switch indexPath.section {
        case 0:
            selectedCategory = nil
        default:
            selectedCategory = self.categories[indexPath.row]
        }
        self.search(searchString: nil, category: selectedCategory)
    }
}

//MARK: UISearchBar

extension ShoppingViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.refreshSearchHistoryTableViewVisibility()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchFromSearchBarText()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchFromSearchBarText()
    }
    
    func closeSearch() {
        self.searchBar.resignFirstResponder()
        self.refreshSearchHistoryTableViewVisibility()
        self.searchHistoryTableView.reloadData()
    }
    
    func searchFromSearchBarText() {
        var searchString: String? = searchBar.text
        if searchString == "" {
            searchString = nil
        }
        self.search(searchString: searchString, category: nil)
        self.closeSearch()
    }
    
    func search(searchString: String?, category: Category?) {
        
        self.remoteAPI.getProducts(searchString: searchString, category: category, success: { products in
            self.products = products
            self.tableView.reloadData()
            self.scrollToTop()
            if let searchString = searchString, searchString != "", let user = self.user {
                self.remoteAPI.addToSearchHistory(user: user, searchString: searchString, success: {}, failure: { error in
                    print(error.localizedDescription)
                })
            }
        }, failure: { error in
            print(error.localizedDescription)
        })
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



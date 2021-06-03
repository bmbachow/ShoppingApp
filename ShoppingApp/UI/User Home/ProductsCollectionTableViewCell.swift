//
//  ProductsCollectionTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//

import UIKit

class ProductsCollectionTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        
    }
    
    
}

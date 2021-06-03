//
//  ProductDetailMainTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/24/21.
//

import UIKit

class ProductDetailMainTableViewCell: BaseTableViewCell {

    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var addToWishListButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.cosmosView.settings.fillMode = .precise
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

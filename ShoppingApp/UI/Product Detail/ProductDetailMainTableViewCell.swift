//
//  ProductDetailMainTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/24/21.
//

import UIKit

class ProductDetailMainTableViewCell: UITableViewCell {

    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

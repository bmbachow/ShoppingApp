//
//  ShoppingProductPreviewTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/24/21.
//

import UIKit

class ShoppingProductPreviewTableViewCell:
    

    UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
        
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productRating: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productRating.settings.fillMode = .precise
        self.productRating.isUserInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

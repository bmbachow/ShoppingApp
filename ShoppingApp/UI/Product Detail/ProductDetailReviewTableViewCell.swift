//
//  ProductDetailReviewTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//

import UIKit

class ProductDetailReviewTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var usernameTextView: UITextView!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var reviewDateTextView: UITextView!
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cosmosView.isUserInteractionEnabled = false
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width/2
        self.userImageView.clipsToBounds = true
        self.userImageView.contentMode = .scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

//
//  WishListTableViewCell.swift
//  ShoppingApp
//
//  Created by Brian Bachow on 5/27/21.
//

import UIKit

protocol WishListTableViewCellDelegate: AnyObject {
    func tappedAddToCartButton(inCell cell: WishListTableViewCell)
    func tappedDeleteButton(inCell cell: WishListTableViewCell)
}

class WishListTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
       
    weak var delegate: WishListTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func tappedDeleteButton(_ sender: Any) {
        self.delegate?.tappedDeleteButton(inCell: self)
    }
    

    @IBAction func tappedAddToCartButton(_ sender: Any) {
        self.delegate?.tappedAddToCartButton(inCell: self)
    }
    
}

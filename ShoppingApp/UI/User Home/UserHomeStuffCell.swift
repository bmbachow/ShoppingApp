//
//  GiftCardBalanceTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/3/21.
//

import UIKit

class UserHomeStuffCell: UITableViewCell {
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

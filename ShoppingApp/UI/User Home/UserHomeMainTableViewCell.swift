//
//  UserHomeMainTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//

import UIKit

class UserHomeMainTableViewCell: BaseTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var memberSinceLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width/2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.contentMode = .scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

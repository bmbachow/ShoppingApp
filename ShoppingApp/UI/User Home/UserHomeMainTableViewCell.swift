//
//  UserHomeMainTableViewCell.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//

import UIKit

class UserHomeMainTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var memberSinceLabel: UILabel!
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        Bundle.main.loadNibNamed("UserHomeMainTableViewCell", owner: self, options: nil)
        self.contentView.fixInView(self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

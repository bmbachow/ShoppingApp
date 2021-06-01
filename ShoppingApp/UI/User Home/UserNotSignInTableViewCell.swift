//
//  UserNotSignInTableViewCell.swift
//  ShoppingApp
//
//  Created by Daivion Prater on 6/1/21.
//

import UIKit

class UserNotSignInTableViewCell: UITableViewCell {


    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        Bundle.main.loadNibNamed("UserNotSignInTableViewCell", owner: self, options: nil)
        self.contentView.fixInView(self)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

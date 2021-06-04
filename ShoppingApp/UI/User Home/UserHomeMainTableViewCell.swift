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
    
    @IBOutlet weak var profileImageView: ButtonImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width/2
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.tintColor = UIConstants.accentColorApp
    }

    func configure(name: String, memberSince: String, profileImage: UIImage?) {
        self.nameLabel.text = name
        self.memberSinceLabel.text = memberSince
        self.setProfileImage(profileImage)
    }
    
    func setProfileImage(_ profileImage: UIImage?) {
        if let image = profileImage {
            self.profileImageView.image = image
            self.profileImageView.clipsToBounds = true
        } else {
            self.profileImageView.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
            self.profileImageView.clipsToBounds = false
        }
    }
}

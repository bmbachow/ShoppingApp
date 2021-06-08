//
//  PasswordTextField.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/8/21.
//

import UIKit

class PasswordTextField: UITextField {
    
    enum ButtonImage: String {
        case eye = "eye"
        case eyeSlash = "eye.slash"
    }
    
    private(set) var showsPassword = false
    
    let button = UIButton()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.clearsOnBeginEditing = false
        self.rightView = self.button
        self.button.addTarget(self, action: #selector(self.tappedEyeButton(_:)), for: .touchUpInside)
        self.updateViews()
    }
    
    func updateViews() {
        self.button.setImage(UIImage(systemName: self.showsPassword ? ButtonImage.eye.rawValue : ButtonImage.eyeSlash.rawValue), for: .normal)
        self.textContentType = self.showsPassword ? .none : .oneTimeCode
    }
    
    @objc func tappedEyeButton(_ sender: UIButton) {
        self.showsPassword.toggle()
    }
}

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
    
    override var isSecureTextEntry: Bool {
        didSet {
            if self.isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.clearsOnBeginEditing = false
        self.rightView = self.button
        self.rightViewMode = .always
        self.button.addTarget(self, action: #selector(self.tappedEyeButton(_:)), for: .touchUpInside)
        self.button.tintColor = .black
        self.updateViews()
    }
    
    func updateViews() {
        self.button.setImage(UIImage(systemName: self.showsPassword ? ButtonImage.eye.rawValue : ButtonImage.eyeSlash.rawValue)!, for: .normal)
        self.textContentType = self.showsPassword ? .none : .oneTimeCode
        self.isSecureTextEntry = !self.showsPassword
    }
    
    @objc func tappedEyeButton(_ sender: UIButton) {
        self.showsPassword.toggle()
        self.updateViews()
    }
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 6
        return rect
    }
}

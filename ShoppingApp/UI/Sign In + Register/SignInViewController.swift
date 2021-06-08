//
//  SignInViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/21/21.
//

import UIKit

class SignInViewController: BaseViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var pass: PasswordTextField!
    
    let anonymousUser: AnonymousUser?
    
    var tappedRegisterAction: (() -> Void)
    
    weak var presentingUserTabViewController: UserTabViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let credentials = KeychainHelper().retrieveLoginCredentials() {
            self.userName.text = credentials.userID
            self.pass.text = credentials.password
        }
    }
    
    init(presentingUserTabViewController: UserTabViewController?, anonymousUser: AnonymousUser?, tappedRegisterAction: @escaping () -> Void) {
        self.presentingUserTabViewController = presentingUserTabViewController
        self.anonymousUser = anonymousUser
        self.tappedRegisterAction = tappedRegisterAction
        super.init(nibName: "SignInViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let userName = self.userName.textnoEmptyString,
              let pass = self.pass.textnoEmptyString else{
            return
        }
        remoteAPI.authenticateAndGetUser(emailOrPhoneNumber: userName, password: pass, anonymousUser: self.anonymousUser, success: { useroptional in
            guard let user = useroptional else {
                return presentBasicAlert(title: "Invalid Sign-In", message: "Check the email/phone or password", onDismiss: nil)
                
            }
            self.presentingUserTabViewController?.user = user
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            
        }, failure: {error in
            
            print(error.localizedDescription)
            
        })
    }
    
    @IBAction func tappedRegisterButton(_ sender: UIButton) {
        self.tappedRegisterAction()
    }
}

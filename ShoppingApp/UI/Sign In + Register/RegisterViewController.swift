//
//  RegisterViewController.swift
//  ShoppingApp
//
//  Created by Daivion Prater on 5/25/21.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var pass: PasswordTextField!
    @IBOutlet weak var confirmPass: PasswordTextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    weak var presentingUserTabViewController: UserTabViewController?
    
    let anonymousUser: AnonymousUser?
    
    var tappedSignInAction: (() -> Void)
    
    init(presentingUserTabViewController: UserTabViewController?, anonymousUser: AnonymousUser?, tappedSignInAction: @escaping () -> Void) {
        self.presentingUserTabViewController = presentingUserTabViewController
        self.anonymousUser = anonymousUser
        self.tappedSignInAction = tappedSignInAction
        super.init(nibName: "RegisterViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func SignUp(_ sender: Any) {
        let presentAlert = {
            self.presentBasicAlert(title: "Invalid Input", message: "No fields can be left blank", onDismiss: nil)
        }
        
        guard let firstName = self.firstName.textnoEmptyString,
              let lastName = self.lastName.textnoEmptyString,
              let email = self.email.textnoEmptyString,
              let phone = self.phone.textnoEmptyString,
              let pass = self.pass.textnoEmptyString,
              let confirmPass = self.confirmPass.textnoEmptyString else {
            return presentAlert()
        }
        var validationMessages = [String]()
        if(!InputValidator.Email.validate(email)){
            validationMessages += ["Invalid email address"]
        }
        if(!InputValidator.PhoneNumber.validate(phone)){
            validationMessages += ["Invalid phone number"]
        }
        if(!InputValidator.Password.validate(pass)){
            validationMessages += [InputValidator.Password.requirementsMessage]
        }
        
        if(pass != confirmPass){
            validationMessages += ["Passwords do not match, check password submission"]
        }
        if(!validationMessages.isEmpty){
            return presentBasicAlert(title: "Invalid Input", message: validationMessages.joined(separator: "\n\n"), onDismiss: nil)
        }
        else{
            remoteAPI.postNewUser(firstName: firstName, lastName: lastName, email: email, phoneNumber: phone, password: pass, anonymousUser: self.anonymousUser, success: {user in
                self.presentBasicAlert(title: "Registered successfully", message: "You will now be signed in to your account.", onDismiss: {
                    self.presentingUserTabViewController?.user = user
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            }) { error in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func tappedSignInButton(_ sender: UIButton) {
        self.tappedSignInAction()
    }
    

}

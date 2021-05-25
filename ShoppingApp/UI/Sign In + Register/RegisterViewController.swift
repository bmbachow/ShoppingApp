//
//  RegisterViewController.swift
//  ShoppingApp
//
//  Created by Daivion Prater on 5/25/21.
//

import UIKit

class RegisterViewController: UserTabViewController {

    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    
    
    
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
            remoteAPI.postNewUser(firstName: firstName, lastName: lastName, email: email, phoneNumber: phone, password: pass, success: {user in
                self.user = user
            }) { error in
                print(error.localizedDescription)
            }
            print(self.user)
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

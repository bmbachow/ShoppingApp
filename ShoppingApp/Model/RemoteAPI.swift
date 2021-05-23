//
//  RemoteAPI.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

protocol RemoteAPI {
    func postNewUser(firstName: String, lastName: String, email: String?, phoneNumber: String?, password: String, success: (User) -> Void, failure: (Error) -> Void)
    
    func validateAndGetUser(emailOrPhoneNumber: String, password: String, success: (User) -> Void, failure: (Error) -> Void)
}

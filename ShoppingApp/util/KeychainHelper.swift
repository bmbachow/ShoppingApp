//
//  KeychainHelper.swift
//  ResortFeedback
//
//  Created by Robert Olieman on 4/24/21.
//

import Foundation
import KeychainAccess

class KeychainHelper {
    private(set) var service = "com.robertolieman.ShoppingApp"
    
    struct Key {
        static let password = "password"
        static let userID = "userID"
        static let shouldSaveLoginCredentials = "shouldSaveLoginCredentials"
    }
 
    private let keychain: Keychain
    
    init() {
        self.keychain = Keychain(service: service).accessibility(.whenUnlocked)
        if !UserDefaultsHelper().shouldSaveLoginCredentials {
            self.deleteLoginCredentials()
        }
    }
    
    func saveLoginCredentials(_ loginCredentials: LoginCredentials) {
        UserDefaultsHelper().shouldSaveLoginCredentials = true
        self.keychain[Key.userID] = loginCredentials.userID
        self.keychain[Key.password] = loginCredentials.password
    }
    
    func retrieveLoginCredentials() -> LoginCredentials? {
        guard let password = self.keychain[Key.password] else { return nil }
        guard let userID = self.keychain[Key.userID] else { return nil }
        return LoginCredentials(userID: userID, password: password)
    }
    
    func deleteLoginCredentials() {
        UserDefaultsHelper().shouldSaveLoginCredentials = false
        self.keychain[Key.password] = nil
        self.keychain[Key.userID] = nil
    }
    
}

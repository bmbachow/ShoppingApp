//
//  UserDefaultsHelper.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

class UserDefaultsHelper {
    
    let defaults = UserDefaults.standard
    
    struct Key {
        static let shouldSaveLoginCredentials = "shouldSaveLoginCredentials"
        static let databaseWasSeeded = "databaseWasSeeded"
    }
    
    var shouldSaveLoginCredentials: Bool {
        get {
            return self.defaults.bool(forKey: Key.shouldSaveLoginCredentials)
        } set {
            self.defaults.setValue(newValue, forKey: Key.shouldSaveLoginCredentials)
        }
    }
    
    var databaseWasSeeded: Bool {
        get {
            return self.defaults.bool(forKey: Key.databaseWasSeeded)
        } set {
            self.defaults.setValue(newValue, forKey: Key.databaseWasSeeded)
        }
    }
}

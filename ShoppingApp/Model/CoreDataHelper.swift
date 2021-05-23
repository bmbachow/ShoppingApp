//
//  CoreDataHelper.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper: RemoteAPI {
    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        self.container.viewContext
    }
    init() {
        self.container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    func postNewUser(firstName: String, lastName: String, email: String?, phoneNumber: String?, password: String, success: (User) -> Void, failure: (Error) -> Void) {
        
    }
    
    func validateAndGetUser(emailOrPhoneNumber: String, password: String, success: (User) -> Void, failure: (Error) -> Void) {
        
    }
}


enum CoreDataHelperError: Error {
    case expectedDataUnavailable(_ details: String)
    case dataCorruption(_ details: String)
    case castingFailure(_ details: String)
    case validationError(_ details: String)
}

extension CoreDataHelperError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .expectedDataUnavailable(details):
            return "Expected data unavailable: \(details)."
        case let .dataCorruption(details):
            return "Data corruption: \(details)"
        case let .castingFailure(details):
            return "Casting failure: \(details)"
        case let .validationError(details):
            return "Validation error: \(details)"
        }
    }
}

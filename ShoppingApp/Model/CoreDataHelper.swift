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
    let bcryptHasher = BCryptHasher.standard
    init(container: NSPersistentContainer) {
        self.container = container
        self.seedDatabaseIfEmpty()
    }
    //MARK: User
    func postNewUser(firstName: String, lastName: String, email: String?, phoneNumber: String?, password: String, success: (User) -> Void, failure: (Error) -> Void) {
        do {
            guard email != nil || phoneNumber != nil else {
                return failure(CoreDataHelperError.validationError("User must have email or phoneNumber."))
            }
            if let email = email {
                guard InputValidator.Email.validate(email) else {
                    return failure(CoreDataHelperError.validationError("Invalid email address"))
                }
            }
            if let phoneNumber = phoneNumber {
                guard InputValidator.PhoneNumber.validate(phoneNumber) else {
                    return failure(CoreDataHelperError.validationError("Invalid phone number"))
                }
            }
            let user = User(context: self.viewContext)
            user.firstName = firstName
            user.lastName = lastName
            user.email = email
            user.phoneNumber = phoneNumber
            user.password = try bcryptHasher.hashPasword(password)
            try self.viewContext.save()
            success(user)
        } catch {
            failure(error)
        }
    }
    
    func authenticateAndGetUser(emailOrPhoneNumber: String, password: String, success: (User?) -> Void, failure: (Error) -> Void) {
        do {
            guard let user = try getUserSync(emailOrPhoneNumber: emailOrPhoneNumber) else {
                return success(nil)
            }
            guard let hashedPassword = user.password else {
                return failure(CoreDataHelperError.dataCorruption("Unable to retrieve password from DB."))
            }
            if bcryptHasher.verify(password, matchesHash: hashedPassword) {
                success(user)
            } else {
                success(nil)
            }
        } catch {
            failure(error)
        }
    }
    
    private func getUserSync(emailOrPhoneNumber: String) throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate =
            NSCompoundPredicate(orPredicateWithSubpredicates:
                                    [
                                        NSPredicate(format: "email == %@", emailOrPhoneNumber),
                                        NSPredicate(format: "phoneNumber == %@", emailOrPhoneNumber)
                                    ])
        let arr = try self.viewContext.fetch(request)
        if arr.count > 1 {
            throw CoreDataHelperError.dataCorruption("Duplicate user in DB.")
        }
        if arr.count < 1 {
            return nil
        }
        let user = arr[0]
        return user
    }
    func getUser(emailOrPhoneNumber: String, success: (User?) -> Void, failure: (Error) -> Void) {
        do {
            let user = try self.getUserSync(emailOrPhoneNumber: emailOrPhoneNumber)
            success(user)
        } catch {
            failure(error)
        }
    }
    
    //MARK: Product
    func postNewProduct(name: String, category: Category, price: Double, productDescription: String, image: UIImage, success: (Product) -> Void, failure: (Error) -> Void) {
        let product = Product(context: self.viewContext)
        product.name = name
        product.category = category
        product.price = price
        product.productDescription = productDescription
        product.setImageDataFromImage(image)
        do {
            try self.viewContext.save()
            success(product)
        } catch {
            failure(error)
        }
    }
  
    func postNewProduct(name: String, categoryName: String, price: Double, productDescription: String, image: UIImage, success: (Product) -> Void, failure: (Error) -> Void) {
        do {
            guard let category = try self.getCategorySync(name: name) else {
                return failure(CoreDataHelperError.expectedDataUnavailable("No category exists named \(categoryName)"))
            }
            self.postNewProduct(name: name, category: category, price: price, productDescription: productDescription, image: image, success: success, failure: failure)
        } catch {
            failure(error)
        }
    }
    
    
    //MARK: Order
    func placeOrder(user: User, products: [Product], price: Double, paymentMethod: PaymentMethod, success: (Order) -> Void, failure: (Error) -> Void) {
        let order = Order(context: self.viewContext)
        
        order.user = user
        order.products = NSOrderedSet(array: products)
        order.price = price
        order.paymentMethod = paymentMethod
        order.orderedDate = Date()
        
        let delivery = Delivery(context: self.viewContext)
        order.delivery = delivery
        //MARK: TODO: delivery
        //we need some silly way to simulate delivery data
        
        do {
            try self.viewContext.save()
            success(order)
        } catch {
            failure(error)
        }
    }
    
    //MARK: Category
    func postNewCategory(name: String, image: UIImage, success: (Category) -> Void, failure: (Error) -> Void) {
        let category = Category(context: self.viewContext)
        category.name = name
        category.setImageDataFromImage(image)
        
        do {
            try self.viewContext.save()
            success(category)
        } catch {
            failure(error)
        }
    }
    
    func getCategory(name: String, success: (Category?) -> Void, failure: (Error) -> Void) {
        do {
            let category = try self.getCategorySync(name: name)
            success(category)
        } catch {
            failure(error)
        }
    }
    
    private func getCategorySync(name: String) throws -> Category? {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        let categories = try self.viewContext.fetch(request)
        guard categories.count <= 1 else {
            throw(CoreDataHelperError.dataCorruption("Should only be one category named \(name)"))
        }
        guard categories.count == 1 else {
            return nil
        }
        return categories[0]
    }
    
    //MARK: ProductReview
    
    func postNewProductReview(user: User, product: Product, title: String, body: String, rating: StarRating, success: (ProductReview) -> Void, failure: (Error) -> Void) {
        let review = ProductReview(context: self.viewContext)
        review.user = user
        review.product = product
        review.title = title
        review.body = body
        review.rating = rating.rawValue
        review.postedDate = Date()
        do {
            try self.viewContext.save()
            success(review)
        } catch {
            failure(error)
        }
    }
    
    //MARK: seedDatabaseIfEmpty()
    
    private func seedDatabaseIfEmpty() {
        guard !UserDefaultsHelper().databaseWasSeeded else {
            return
        }
        
        let categories: [(name: String, image: UIImage)] = [
            (name: "Monitors", image: UIImage(named: "")!),
            (name: "Laptops", image: UIImage(named: "")!),
            (name: "Accessories", image: UIImage(named: "")!),
            (name: "Smartphones", image: UIImage(named: "")!),
            (name: "Gaming", image: UIImage(named: "")!)
        ]
        
        let products: [(categoryName: String, name: String, price: Double, productDescription: String, image: UIImage)] = [
            (categoryName: "Monitors", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Monitors", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Monitors", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Monitors", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Monitors", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Accessories", name: "Apple Watch Series 3", price: 229.99, productDescription: "Apple Watch Series 3 with cellular allows you to stay connected, make calls, receive texts and more, even without iPhone nearby", image: UIImage(named: "A-AppleWatch")!),
            (categoryName: "Accessories", name: "PowerBear HDMI Cable", price: 9.99, productDescription: "PowerBear 4K HDMI Cable 10 ft | High Speed, Braided Nylon & Gold Connectors, 4K @ 60Hz, Ultra HD, 2K, 1080P & ARC Compatible | for Laptop, Monitor, PS5, PS4, Xbox One, Fire TV, Apple TV & More", image: UIImage(named: "A-HDMIcable")!),
            (categoryName: "Accessories", name: "Powlight Power Strip", price: 24.98, productDescription: "Power Strip with 8 Ft, Powlight Surge Protector with 12 AC Outlets and 4 USB Charging Ports,1875W/15A, 2100 Joules, 8 Feet Long Extension Cord for Smartphone Tablets Home,Office, Hotel- Black", image: UIImage(named: "A-PowerStrip")!),
            (categoryName: "Accessories", name: "Kasa Smart Plug", price: 13.99, productDescription: "Kasa Smart (HS100) Plug by TP-Link, Smart Home WiFi Outlet Works with Alexa, Echo, Google Home & IFTTT, No Hub Required, Remote Control, 15 Amp, UL Certified", image: UIImage(named: "")!),
            (categoryName: "Accessories", name: "Anker Wireless Charger", price: 18.99, productDescription: "Anker Wireless Charger, PowerWave Stand, Qi-Certified, 10 Watt Fast Charging", image: UIImage(named: "A-WirelessCharger")!),
            (categoryName: "Smartphones", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Smartphones", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Smartphones", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Smartphones", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Smartphones", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Gaming", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Gaming", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Gaming", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Gaming", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Gaming", name: "", price: 0, productDescription: "", image: UIImage(named: "")!)
        ]
    
        
        for category in categories {
            self.postNewCategory(name: category.name, image: category.image, success: {_ in}, failure: {_ in})
        }
        
        for product in products {
            self.postNewProduct(name: product.name, categoryName: product.categoryName, price: product.price, productDescription: product.productDescription, image: product.image, success: {_ in}, failure: {_ in})
        }
        
        UserDefaultsHelper().databaseWasSeeded = true
    }
}


//MARK: Error

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


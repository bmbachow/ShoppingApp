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
            (categoryName: "Monitors", name: "AOC CU32V3 32' Super-Curved 4K UHD monitor, 1500R Curved VA, 4ms, 121% sRGB Coverage / 90% DCI-P3, HDMI 2.0/DisplayPort, VESA, Black", price: 0, productDescription: "", image: UIImage(named: "d-aocmonitor")!),
            (categoryName: "Monitors", name: "LG 32UL500-W 32 Inch UHD (3840 x 2160) VA Display with AMD FreeSync, DCI-P3 95% Color Gamut and HDR 10 Compatibility, Silver/White, Silve/White", price: 0, productDescription: "", image: UIImage(named: "d-lg32inch")!),
            (categoryName: "Monitors", name: "Dell SE2419Hx 24' IPS Full HD (1920x1080) Monitor, Black", price: 0, productDescription: "", image: UIImage(named: "d-dell24inch")!),
            (categoryName: "Monitors", name: "ASUS VP249QGR 23.8” Gaming Monitor 144Hz Full HD (1920 x 1080) IPS 1ms FreeSync Extreme Low Motion Blur Eye Care DisplayPort HDMI VGA,BLACK",
             price: 0, productDescription: "", image: UIImage(named: "d-asusgaming")!),
            (categoryName: "Monitors", name: "Philips 328E1CA 32' Curved Monitor, 4K UHD, 120% sRGB, Adaptive-Sync, Speakers, Vesa, 4Yr Advance Replacement Warranty",
             price: 0, productDescription: "", image: UIImage(named: "d-phillipsmonitor")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Laptops", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Accessories", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Accessories", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Accessories", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Accessories", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
            (categoryName: "Accessories", name: "", price: 0, productDescription: "", image: UIImage(named: "")!),
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
    
        //MARK: TODO: create dummy data
        
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


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
            guard let category = try self.getCategorySync(name: categoryName) else {
                return failure(CoreDataHelperError.expectedDataUnavailable("No category exists named \(categoryName)"))
            }
            self.postNewProduct(name: name, category: category, price: price, productDescription: productDescription, image: image, success: success, failure: failure)
        } catch {
            failure(error)
        }
    }
    
    func getAllProducts(success: ([Product]) -> Void, failure: (Error) -> Void) {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            let products = try self.viewContext.fetch(request)
            success(products)
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
    
    func postNewProductReview(user: User?, product: Product, title: String, body: String, rating: StarRating, success: (ProductReview) -> Void, failure: (Error) -> Void) {
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
            (name: "Monitors", image: UIImage()),
            (name: "Laptops", image: UIImage()),
            (name: "Accessories", image: UIImage()),
            (name: "Smartphones", image: UIImage()),
            (name: "Gaming", image: UIImage())
        ]
        
        let products: [(categoryName: String, name: String, price: Double, productDescription: String, image: UIImage)] = [
            (categoryName: "Monitors", name: "AOC CU32V3 32' Super-Curved 4K UHD monitor, 1500R Curved VA, 4ms, 121% sRGB Coverage / 90% DCI-P3, HDMI 2.0/DisplayPort, VESA, Black", price: 0, productDescription: "", image: UIImage(named: "d-aocmonitor")!),
            (categoryName: "Monitors", name: "LG 32UL500-W 32 Inch UHD (3840 x 2160) VA Display with AMD FreeSync, DCI-P3 95% Color Gamut and HDR 10 Compatibility, Silver/White, Silve/White", price: 0, productDescription: "", image: UIImage(named: "d-lg32inch")!),
            (categoryName: "Monitors", name: "Dell SE2419Hx 24' IPS Full HD (1920x1080) Monitor, Black", price: 0, productDescription: "", image: UIImage(named: "d-dell24inch")!),
            (categoryName: "Monitors", name: "ASUS VP249QGR 23.8” Gaming Monitor 144Hz Full HD (1920 x 1080) IPS 1ms FreeSync Extreme Low Motion Blur Eye Care DisplayPort HDMI VGA,BLACK",
             price: 0, productDescription: "", image: UIImage(named: "d-asusgaming")!),
            (categoryName: "Monitors", name: "Philips 328E1CA 32' Curved Monitor, 4K UHD, 120% sRGB, Adaptive-Sync, Speakers, Vesa, 4Yr Advance Replacement Warranty",
             price: 0, productDescription: "", image: UIImage(named: "d-phillipsmonitor")!),
            (
                categoryName: "Laptops",
                name: "2020 Flagship HP 14 Chromebook Laptop Computer 14\" HD SVA Anti-Glare Display Intel Celeron Processor 4GB DDR4 64GB eMMC Backlit WiFi Webcam Chrome OS (Renewed)",
                price: 199.00,
                productDescription: "",
                image: UIImage(named: "l-hp")!),
            (
                categoryName: "Laptops",
                name: "Acer Aspire 5 Slim Laptop, 15.6 inches Full HD IPS Display, AMD Ryzen 3 3200U, Vega 3 Graphics, 4GB DDR4, 128GB SSD, Backlit Keyboard, Windows 10 in S Mode, A515-43-R19L, Silver",
                price: 431.00,
                productDescription: "",
                image: UIImage(named: "l-acer")!),
            (
                categoryName: "Laptops",
                name: "2020 Apple MacBook Air with Apple M1 Chip (13-inch, 8GB RAM, 256GB SSD Storage) - Space Gray",
                price: 949.00,
                productDescription: "",
                image: UIImage(named: "l-macbook")!),
            (
                categoryName: "Laptops",
                name: "Alienware m17 R4, 17.3 inch FHD (Full HD) Gaming Laptop - Intel Core i7-10870H, 16GB DDR4 RAM, 1TB SSD, NVIDIA GeForce RTX 3060 6GB GDDR6, Windows 10 Home - Lunar Light (Latest Model)",
                price: 2359.99,
                productDescription: "",
                image: UIImage(named: "l-alienware")!),
            (
                categoryName: "Laptops",
                name: "2021 Newest Dell Inspiron 3000 Business Laptop, 15.6 HD LED-Backlit Display, Intel Celeron Processor N4020, 8GB DDR4 RAM, 128GB PCIe SSD, Online Meeting Ready, Webcam, WiFi, HDMI, Win10 Pro, Black",
                price: 449.00,
                productDescription: "",
                image: UIImage(named: "l-dell")!),
            (categoryName: "Accessories", name: "Apple Watch Series 3", price: 229.99, productDescription: "Apple Watch Series 3 with cellular allows you to stay connected, make calls, receive texts and more, even without iPhone nearby", image: UIImage(named: "A-AppleWatch")!),
            (categoryName: "Accessories", name: "PowerBear HDMI Cable", price: 9.99, productDescription: "PowerBear 4K HDMI Cable 10 ft | High Speed, Braided Nylon & Gold Connectors, 4K @ 60Hz, Ultra HD, 2K, 1080P & ARC Compatible | for Laptop, Monitor, PS5, PS4, Xbox One, Fire TV, Apple TV & More", image: UIImage(named: "A-HDMIcable")!),
            (categoryName: "Accessories", name: "Powlight Power Strip", price: 24.98, productDescription: "Power Strip with 8 Ft, Powlight Surge Protector with 12 AC Outlets and 4 USB Charging Ports,1875W/15A, 2100 Joules, 8 Feet Long Extension Cord for Smartphone Tablets Home,Office, Hotel- Black", image: UIImage(named: "A-PowerStrip")!),
            (categoryName: "Accessories", name: "Kasa Smart Plug", price: 13.99, productDescription: "Kasa Smart (HS100) Plug by TP-Link, Smart Home WiFi Outlet Works with Alexa, Echo, Google Home & IFTTT, No Hub Required, Remote Control, 15 Amp, UL Certified", image: UIImage(named: "A-WIFIplug")!),
            (categoryName: "Accessories", name: "Anker Wireless Charger", price: 18.99, productDescription: "Anker Wireless Charger, PowerWave Stand, Qi-Certified, 10 Watt Fast Charging", image: UIImage(named: "A-WirelessCharger")!),
            (
                categoryName: "Smartphones",
                name: "TCL 10L, Unlocked Android Smartphone with 6.53\" FHD + LCD Display, 48MP Quad Rear Camera System, 64GB+6GB RAM, 4000mAh Battery - Arctic White",
                price: 249.99,
                productDescription: "",
                image: UIImage(named: "s-tcl")!),
            (
                categoryName: "Smartphones",
                name: "LG G8 ThinQ LMG820TM 128GB T-Mobile Unlocked Phone - Carmine Red",
                price: 319.99,
                productDescription: "",
                image: UIImage(named: "s-lg")!),
            (
                categoryName: "Smartphones",
                name: "Google Pixel 4a with 5G - Android Phone - New Unlocked Smartphone with Night Sight and Ultrawide Lens - Clearly White",
                price: 499.00,
                productDescription: "",
                image: UIImage(named: "s-google")!),
            (
                categoryName: "Smartphones",
                name: "Samsung Electronics Samsung Galaxy S21 5G | Factory Unlocked Android Cell Phone | US Version 5G Smartphone | Pro-Grade Camera, 8K Video, 64MP High Res | 128GB, Phantom Gray (SM-G991UZAAXAA)",
                price: 699.99,
                productDescription: "",
                image: UIImage(named: "s-samsung")!),
            (
                categoryName: "Smartphones",
                name: "New Apple iPhone 12 (64GB, Blue) [Locked] + Carrier Subscription",
                price: 829.00,
                productDescription: "",
                image: UIImage(named: "s-apple")!),

            (categoryName: "Gaming", name: "AKRacing Gaming Chair", price: 399.99, productDescription: "AKRacing Core Series EX-Wide SE Ergonomic Red Gaming Chair with Wide Seat, 330 Lbs Weight Limit, Rocker and Seat Height Adjustment Mechanisms", image: UIImage(named: "racingChair")!),
            (categoryName: "Gaming", name: "BENGOO G9000 Stereo Gaming Headset", price: 19.99, productDescription: "Stereo Gaming Headset for PS4 PC Xbox One PS5 Controller, Noise Cancelling Over Ear Headphones with Mic, LED Light, Bass Surround, Soft Memory Earmuffs for Laptop Mac Nintendo NES Games", image: UIImage(named: "gamingHeadset")!),
            (categoryName: "Gaming", name: "Nintendo Switch", price: 299.98, productDescription: "Hybrid video game console, consisting of a console unit, a dock, and two Joy-Con controllers", image: UIImage(named: "nintendoSwitch")!),
            (categoryName: "Gaming", name: "Microsoft Xbox Series X", price: 1249.00, productDescription: "Microsoft Xbox Series X 1TB SSD Video Game Console + 1 Xbox Wireless Controller - 8X Cores Zen 2 CPU, RDNA 2 GPU, 16GB GDDR6 Memory, True 4K Gaming, 8K HDR, 120 FPS, 4K UHD Blu-Ray - Broage HDMI Cable", image: UIImage(named: "xboxSeriesX")!),
            (categoryName: "Gaming", name: "Playstation 5", price: 1099.99, productDescription: "Playstation 5 Home Video Game Console: Blu-Ray Edition", image: UIImage(named: "playstation5")!)

        ]
    
        
        for category in categories {
            self.postNewCategory(name: category.name, image: category.image, success: {_ in}, failure: {_ in})
        }
        
        for productData in products {
            self.postNewProduct(name: productData.name, categoryName: productData.categoryName, price: productData.price, productDescription: productData.productDescription, image: productData.image, success: { product in
                for _ in 0..<20 {
                    let reviewData = self.generateRandomReviewData()
                    self.postNewProductReview(user: nil, product: product, title: reviewData.title, body: reviewData.body, rating: reviewData.rating, success: {_ in}, failure: {_ in})
                }
            }, failure: {_ in})
        }
        
        try? self.viewContext.save()
        
        UserDefaultsHelper().databaseWasSeeded = true
    }
    
    private func generateRandomReviewData() -> (rating: StarRating, title: String, body: String) {
        let starRating: StarRating = {
            let random = Double.random(in: 0...1)
            if random > 0.6 {
                return .five
            } else if random > 0.35 {
                return .four
            } else if random > 0.2 {
                return .three
            } else if random > 0.1 {
                return .two
            } else {
                return .one
            }
        }()
        
        let review: (title: String, body: String) = {
            switch starRating {
            case .one:
                return [
                    (title: "Crap",
                     body: "I hate it."
                    ),
                    (title: "Terrible!",
                     body: "This thing is garbage."
                    ),
                    (title: "Worse than death",
                     body: "Honestly not good at all. I want my money back."
                    ),
                    (title: "Why?",
                     body: "It should be illegal to sell this product."
                    ),
                    (title: "Do not buy!",
                     body: "Worst purchase I ever made."
                    )
                ].randomElement()!
            case .two:
                return [
                    (title: "Mostly junk",
                     body: "Pretty bad product. Not recommended."
                    ),
                    (title: "Ugh",
                     body: "Seemed ok at first, but broke after second use."
                    ),
                    (title: "Save your money!",
                     body: "Not at all worth the price. I returned it and bought a better one."
                    ),
                    (title: "Sad",
                     body: "Extremely disappointed. I had such high hopes. I don't know what to believe anymore."
                    ),
                    (title: "Nice paperweight",
                     body: "Looks really cool but doesn't work at all."
                    )
                ].randomElement()!
            case .three:
                return [
                    (title: "Meh",
                     body: "Not the absolute worst. Sort of alright I guess. I've seen better. "
                    ),
                    (title: "Bored",
                     body: "Has some nice features, but there are better options out there."
                    ),
                    (title: "Overpriced",
                     body: "Would be great if it were about half as expensive. Buy a better thing instead."
                    ),
                    (title: "Not for me",
                     body: "Pretty good if you are the type of person who likes this type of thing."
                    ),
                    (title: "Not ready for prime time",
                     body: "I really wanted to love this product, but unfortunately it has some serious flaws. Maybe the next version will be better."
                    )
                ].randomElement()!
            case .four:
                return [
                    (title: "Very nice",
                     body: "Really really good but not the best. But still pretty great."
                    ),
                    (title: "They don't make em like they used to",
                     body: "This is the best I could find, but still not as good as my old 2011 model."
                    ),
                    (title: "Almost perfect",
                     body: "I would have given this thing 5 stars if it didn't do that one dumb thing I hate!"
                    ),
                    (title: "One of the best",
                     body: "This is seriously amazing, but I don't give away 5 star reviews as haphazardly as some people."
                    ),
                    (title: "Pretty good product",
                     body: "I like it a lot but I had to return it because it's not user friendly enough for my Grandma."
                    ),
                    (title: "A minus",
                     body: "Keep trying, you're almost there."
                    )
                ].randomElement()!
            case .five:
                return [
                    (title: "Awesome!",
                     body: "I didn't know it was possible to make a thing this good. I stare at it all day."
                    ),
                    (title: "Incredible",
                     body: "Best on the market! I bought 18."
                    ),
                    (title: "Best dollars I ever spent",
                     body: "If you only ever buy one thing, buy this product! You will not regret it. It's worth the money. Sell your house if you have to."
                    ),
                    (title: "500 stars",
                     body: "I was skeptical at first, but now I know this is the best one of these ever made. 5 stars is not enough!"
                    ),
                    (title: "Changed my life",
                     body: "I can't even stand how wonderful this freaking thing is. It made me a better person!"
                    ),
                    (title: "My eyes are opened",
                     body: "I thought I knew what a good one of these looked like, but I knew nothing until I bought this thing."
                    ),
                    (title: "It does everything",
                     body: "My old one did less things, but this one has every feature."
                    ),
                    (title: "Speechless",
                     body: "I can't find the words to express how perfect this product is.")
                ].randomElement()!
            }
        }()
        
        return (rating: starRating, title: review.title, body: review.body)
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


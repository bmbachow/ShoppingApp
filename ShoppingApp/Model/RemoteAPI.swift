//
//  RemoteAPI.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit

protocol RemoteAPI {
    //MARK: User
    func postNewUser(firstName: String, lastName: String, email: String?, phoneNumber: String?, password: String, success: (User) -> Void, failure: (Error) -> Void)
    
    func authenticateAndGetUser(emailOrPhoneNumber: String, password: String, success: (User?) -> Void, failure: (Error) -> Void)
    
    func getUser(emailOrPhoneNumber: String, success: (User?) -> Void, failure: (Error) -> Void)
    
    //MARK: Cart
    
    func addProductToCart(product: Product, user: User, success: () -> Void, failure: (Error) -> Void)
    
    func changeCartItemNumber(cartItem: CartItem, number: Int, success: () -> Void, failure: (Error) -> Void)
    
    func deleteItemFromCart(cartItem: CartItem, success: () -> Void, failure: (Error) -> Void)
    
    //MARK: Wish List
    
    func addProductToWishList(product: Product, user: User, success: () -> Void, failure: (Error) -> Void)
    
    func deleteProductFromWishList(product: Product, user: User, success: () -> Void, failure: (Error) -> Void)
    
    
    //MARK: Product
    func postNewProduct(name: String, category: Category, price: Double, productDescription: String, image: UIImage, success: (Product) -> Void, failure: (Error) -> Void)
    
    func postNewProduct(name: String, categoryName: String, price: Double, productDescription: String, image: UIImage, success: (Product) -> Void, failure: (Error) -> Void)
    
    func getAllProducts(success: ([Product]) -> Void, failure: (Error) -> Void)
    
    //MARK: Order
    func placeOrder(user: User, products: [Product], price: Double, paymentMethod: PaymentMethod, success: (Order) -> Void, failure: (Error) -> Void)
    
    
    //MARK: Category
    
    func getAllCategories(success: ([Category]) ->  Void, failure: (Error) -> Void)
    
    func getCategory(name: String, success: (Category?) -> Void, failure: (Error) -> Void)
    
    func postNewCategory(name: String, image: UIImage, success: (Category) -> Void, failure: (Error) -> Void)
    
    //MARK: ProductReview
    func postNewProductReview(user: User?, product: Product, title: String, body: String, rating: StarRating, success: (ProductReview) -> Void, failure: (Error) -> Void)
}

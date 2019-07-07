//
//  CartViewModel.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/6.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation

protocol CartViewModelProtocol {
    var titleText: String { get }
    var totalPrice: String? { get }
    var cartProducts: [CartEntity]? {get set}
    var productsDidChange: ((CartViewModelProtocol) -> ())? { get set }
    
    init(title : String)
    func fetchAllProducts()
    func checkout()
}

class CartViewModel: CartViewModelProtocol {
    var titleText = ""
    var totalPrice: String?
    var productsDidChange: ((CartViewModelProtocol) -> ())?
    var cartProducts: [CartEntity]? {
        didSet {
            self.productsDidChange?(self)
        }
    }

    required init(title: String) {
        self.titleText = title
    }
    
    func fetchAllProducts() {
        if let cartProducts = CoreDataManager.sharedInstance.fetchProductsInCart() {
            var totalPrice: Double = 0
            for cartEntity in cartProducts {
                if let variants = cartEntity.product?.variants?.allObjects as? [VariantEntity], variants.count > 0 {
                    let productPrice = Double(variants[0].price)
                    totalPrice = totalPrice + productPrice
                    if let tax = cartEntity.product?.tax?.value {
                        totalPrice = totalPrice + productPrice * (tax / 100.0)
                    }
                }
            }
            self.totalPrice = String(totalPrice)
            self.cartProducts = cartProducts
        }
    }
    
    func checkout() {
        if let cartProducts = cartProducts, cartProducts.count > 0 {
            
        }
    }
}

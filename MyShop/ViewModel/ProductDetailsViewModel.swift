//
//  ProductDetailsViewModel.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/6.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation

protocol ProductDetailsViewModelProtocol {
    var titleText: String { get }
    var product: ProductEntity {get}
    var selectedVariant: VariantEntity? {get set}
    //var categoriesDidChange: ((CategoryViewModelProtocol) -> ())? { get set } // function to call when greeting did change
    
    init(product: ProductEntity, title : String)
    func addToCart()
    func buyProduct()
}

class ProductDetailsViewModel: ProductDetailsViewModelProtocol {
    var titleText = ""
    var product: ProductEntity
    var selectedVariant: VariantEntity?
    weak var delegate: RefreshHomeViewProtocol?
    
    required init(product: ProductEntity, title: String) {
        titleText = title
        if let variants = product.variants?.allObjects as? [VariantEntity], variants.count > 0 {
            selectedVariant = variants[0] 
        }
        self.product = product
    }
    
    func buyProduct() {
        
    }
    
    func addToCart() {
        _ = CoreDataManager.sharedInstance.insertInCart(product: product, variant: selectedVariant)
        CoreDataManager.sharedInstance.saveContext()
    }
}

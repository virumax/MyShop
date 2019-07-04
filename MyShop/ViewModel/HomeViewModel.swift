//
//  HomeViewModel.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/2.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation

protocol RefreshHomeViewProtocol: class {
    func refreshHomeView(forCategory: CategoriesEntity)
}

protocol HomeViewModelProtocol {
    var titleText: String { get }
    var products: [ProductEntity]? { get }
    var categories: [CategoriesEntity]? { get }
    var productsDidChange: ((HomeViewModelProtocol) -> ())? { get set } // function to call when greeting did change
    
    init(apiService: APIService)
    func fetchData()
    func getCategories(completionHandler: ([CategoriesEntity]?) -> Void)
    func getRankings(completionHandler: ([RankingEntity]?) -> Void)
    func getProductsForRanking(name: String)
    func getVariants(completionHandler: ([VariantEntity]?) -> Void)
}

class HomeViewModel: HomeViewModelProtocol, RefreshHomeViewProtocol {
    var categories: [CategoriesEntity]?
    let titleText = "MyShop"
    var apiService: APIService
    var productsDidChange: ((HomeViewModelProtocol) -> ())?
    var products: [ProductEntity]? {
        didSet {
            self.productsDidChange?(self)
        }
    }
    
    required init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchData() {
        // Fetch the categories to check whether DB has been updated
        if let products = CoreDataManager.sharedInstance.fetchProducts(), products.count > 0 {
            // Records are present already
            self.products = products
        } else {
            self.apiService.fetchData { [weak self](baseModel, error) in
                if let baseModel = baseModel {
                    CoreDataManager.sharedInstance.insertData(baseModel)
                    if let products = CoreDataManager.sharedInstance.fetchProducts(), products.count > 0 {
                        // Records are present already
                        self?.products = products
                    }
                }
            }
        }
    }
    
    func getCategories(completionHandler: ([CategoriesEntity]?) -> Void) {
        // Fetch the categories
        if let categories = CoreDataManager.sharedInstance.fetchCategories(), categories.count > 0 {
            completionHandler(categories)
        } else {
            completionHandler(nil)
        }
    }
    
    func refreshHomeView(forCategory: CategoriesEntity) {
        products = forCategory.products?.allObjects as? [ProductEntity]
    }
    
    func getRankings(completionHandler: ([RankingEntity]?) -> Void) {
        // Fetch the rankings
        if let rankings = CoreDataManager.sharedInstance.fetchRankings(), rankings.count > 0 {
            completionHandler(rankings)
        } else {
            completionHandler(nil)
        }
    }
    
    func getProductsForRanking(name: String) {
        // Fetch ranking by name
        if let ranking = CoreDataManager.sharedInstance.fetchRanking(name) {
            if let rankingProducts = ranking.products?.allObjects as? [RankingProductEntity] {
                let productIds = rankingProducts.map {Int($0.id)}
                if let products = CoreDataManager.sharedInstance.fetchProducts(forIds: productIds) {
                    self.products = products
                }
            }
        }
    }
    
    func getVariants(completionHandler: ([VariantEntity]?) -> Void) {
        var variants = [VariantEntity]()
        
        if let products = products {
            for product in products {
                if let productVariants = product.variants?.allObjects as? [VariantEntity] {
                    for variant in productVariants {
                        variants.append(variant)
                    }
                }
            }
        }
        completionHandler(variants)
    }
}

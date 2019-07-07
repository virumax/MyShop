//
//  HomeViewModel.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/2.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation
import Alamofire

protocol RefreshHomeViewProtocol: class {
    func refreshHomeView(forCategory: CategoriesEntity)
}

protocol HomeViewModelProtocol {
    var titleText: String { get }
    var products: [ProductEntity]? { get }
    var categories: [CategoriesEntity]? { get }
    var productsDidChange: ((HomeViewModelProtocol) -> ())? { get set } // function to call when products did change
    var currentFilters: [FilterType: [String]] { get set }
    var selectedPickerRow: Int { get set }
    var alertMessage: String? { get }
    var alertMessageDidChange: ((HomeViewModelProtocol) -> ())? { get set }
    
    init(apiService: APIService)
    func fetchData()
    func getCategories(completionHandler: ([CategoriesEntity]?) -> Void)
    func getRankings(completionHandler: ([RankingEntity]?) -> Void)
    func getProductsForRanking(name: String)
    func getVariants(completionHandler: ([VariantEntity]?) -> Void)
    func filterProducts()
    func clearFilters()
    func filterBySearchTerm(searchText: String?)
    func cancelSearch()
    func backupPoductsList()
}

enum FilterType: String {
    case color
    case size
    
    func getTag() -> Int {
        switch self {
        case .color: return 1
        case .size: return 2
        }
    }
}

class HomeViewModel: HomeViewModelProtocol, RefreshHomeViewProtocol {
    var productsListBackup = [ProductEntity]()
    var categories: [CategoriesEntity]?
    let titleText = "MyShop"
    var apiService: APIService
    var productsDidChange: ((HomeViewModelProtocol) -> ())?
    var currentFilters = [FilterType: [String]]()
    var products: [ProductEntity]? {
        didSet {
            self.productsDidChange?(self)
        }
    }
    var selectedPickerRow: Int = -1
    private var reachabilityManager = NetworkReachabilityManager()
    var alertMessageDidChange: ((HomeViewModelProtocol) -> ())?
    var alertMessage: String? {
        didSet {
            self.alertMessageDidChange?(self)
        }
    }
    
    required init(apiService: APIService) {
        self.apiService = apiService
        startListeningNetworkStatus()
    }
    
    func fetchData() {
        // Fetch the categories to check whether DB has been updated
        if let products = CoreDataManager.sharedInstance.fetchProducts(), products.count > 0 {
            // Records are present already
            self.products = products
        } else {
            if NetworkReachabilityManager()!.isReachable {
                self.apiService.fetchData { [weak self](baseModel, error) in
                    if let baseModel = baseModel {
                        CoreDataManager.sharedInstance.insertData(baseModel)
                        if let products = CoreDataManager.sharedInstance.fetchProducts(), products.count > 0 {
                            // Records are present already
                            self?.products = products
                        }
                    }
                }
            } else {
                alertMessage = MyShop_Strings.NO_INTERNET
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
    
    // Filter the products according to color and size variant
    func filterProducts() {
        var filteredProducts = [ProductEntity]()
        if let products = products {
            for product in products {
                if let productVariants = product.variants?.allObjects as? [VariantEntity] {
                    let array = productVariants.filter {[weak self] (product) -> Bool in
                        //var productMatches = true
                        if let colorFilters = self?.currentFilters[.color], colorFilters.count > 0 {
                            let array = colorFilters.filter {$0 == product.color}
                            if array.count == 0 {
                                return false
                            }
                        }
                        
                        if let sizeFilters = self?.currentFilters[.size], sizeFilters.count > 0 {
                            let array = sizeFilters.filter {$0 == String(product.size)}
                            if array.count == 0 {
                                return false
                            }
                        }
                        return true
                    }
                    
                    if array.count > 0 {
                        filteredProducts.append(product)
                        continue
                    }
                }
            }
        }
        
        products = filteredProducts
    }
    
    func backupPoductsList() {
        if let products = products {
            for product in products {
                if let newProduct = product.clone() as? ProductEntity {
                    productsListBackup.append(newProduct)
                }
            }
        }
    }
    
    func filterBySearchTerm(searchText: String?) {
        if let searchText = searchText, searchText.count > 0 {
            products = productsListBackup.filter{ $0.name?.contains(searchText) ?? false}
        } else {
            products = productsListBackup
        }
    }
    
    func cancelSearch() {
        products?.removeAll()
        for product in productsListBackup {
            if let newProduct = product.clone() as? ProductEntity {
                products?.append(newProduct)
            }
        }
        productsListBackup.removeAll()
    }
    
    func clearFilters() {
        currentFilters.removeAll()
        // Fetch the categories to check whether DB has been updated
        if let products = CoreDataManager.sharedInstance.fetchProducts(), products.count > 0 {
            // Records are present already
            self.products = products
        }
    }
    
    // MARK: Private methods
    // Starting to detect network status
    private func startListeningNetworkStatus() {
        self.reachabilityManager?.startListening()
        self.reachabilityManager?.listener = { [unowned self] status in
            switch status {
            case .reachable(.ethernetOrWiFi): // The network is reachable.
               self.fetchData()
            default:
                break
            }
        }
    }
}

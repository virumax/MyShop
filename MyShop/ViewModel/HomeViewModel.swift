//
//  HomeViewModel.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/2.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {
    var products: [ProductEntity]? { get }
    var productsDidChange: ((HomeViewModelProtocol) -> ())? { get set } // function to call when greeting did change
    init(apiService: APIService)
    func fetchData()
}

class HomeViewModel: HomeViewModelProtocol {
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
        if let categories = CoreDataManager.sharedInstance.fetchCategories(), categories.count > 0 {
            // Records are present already
            showProducts()
        } else {
            self.apiService.fetchData { [weak self](baseModel, error) in
                if let baseModel = baseModel {
                    CoreDataManager.sharedInstance.insertData(baseModel)
                    self?.showProducts()
                }
            }
        }
    }
    
    func showProducts() {
        products = CoreDataManager.sharedInstance.fetchProducts()
    }
}

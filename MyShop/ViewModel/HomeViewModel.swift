//
//  HomeViewModel.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/2.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {
    var products: [CategoryProduct]? { get }
    var productsDidChange: ((HomeViewModelProtocol) -> ())? { get set } // function to call when greeting did change
    init(apiService: APIService)
    func showProducts()
}
class HomeViewModel: HomeViewModelProtocol {
    var apiService: APIService
    var productsDidChange: ((HomeViewModelProtocol) -> ())?
    var products: [CategoryProduct]? {
        didSet {
            self.productsDidChange?(self)
        }
    }
    required init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func showProducts() {
        self.apiService.fetchData { (baseModel, error) in
            if baseModel != nil {
                
            } else {
                
            }
        }
    }
}

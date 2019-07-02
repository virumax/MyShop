//
//  ViewController.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // View model instance
    lazy var viewModel: HomeViewModelProtocol = {
        HomeViewModel(apiService: APIService())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
        
        viewModel.fetchData()
    }
    
    func initViewModel() {
        viewModel.productsDidChange = { [unowned self] viewModel in
            print("Table view should be reloaded")
            print(self)
        }
    }
}


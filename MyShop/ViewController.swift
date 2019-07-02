//
//  ViewController.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let categories = CoreDataManager.sharedInstance.fetchCategories(), categories.count > 0
        {
            print("Records already present")
        } else {
            APIService().fetchData { (baseModel, error) in
                if let baseModel = baseModel {
                    CoreDataManager.sharedInstance.insertData(baseModel)
                }
            }
        }
    }
}


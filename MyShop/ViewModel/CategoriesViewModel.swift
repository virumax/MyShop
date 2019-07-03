//
//  CategoriesViewModel.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/3.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation

public struct CategoryMenu {
    public var mainCategory: CategoriesEntity
    public var subCategories: [CategoriesEntity]
    
    public init(mainCategory: CategoriesEntity, subCategories: [CategoriesEntity]) {
        self.mainCategory = mainCategory
        self.subCategories = subCategories
    }
}

public struct Item {
    public var name: String
    public var detail: String
    
    public init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
}
protocol CategoryViewModelProtocol {
    
    var titleText: String { get }
    var categoryMenu: [CategoryMenu] {get set}
    //var categoriesDidChange: ((CategoryViewModelProtocol) -> ())? { get set } // function to call when greeting did change
    
    init(categories: [CategoriesEntity], title : String)
    func parseCategories(_ categories: [CategoriesEntity])
}

class CategoriesViewModel: CategoryViewModelProtocol {
    var titleText = ""
    var categoryMenu = [CategoryMenu]()
    weak var delegate: RefreshHomeViewProtocol?
    
    required init(categories: [CategoriesEntity], title: String) {
        titleText = title
        parseCategories(categories)
    }
    
    func parseCategories(_ categories: [CategoriesEntity]) {
        if categories.count > 1 { // For parsing the first level of categories
            var categoriesDictionary = [Int: Int]()
            
            // Set 1 for the category if it is in sub-category of any category
            for category in categories {
                categoriesDictionary[Int(category.id)] = 1
            }
            for category in categories {
                if let subCategories = category.subCategories {
                    // Need to force cast to [Int] because DB stores it as NSObject
                    for categoryId in subCategories as! [Int] {
                        categoriesDictionary[categoryId] = 0
                    }
                }
            }
            
            // Create a nested level of Categories and SubCategories menu
            for (key, value) in categoriesDictionary {
                if value == 1 {
                    if let category = categories.first(where: {$0.id == key}) {
                        var items = [CategoriesEntity]()
                        if let subCategories = category.subCategories {
                            for subCategoryId in subCategories as! [Int] {
                                if let subCategory = categories.first(where: {$0.id == subCategoryId}) {
                                    items.append(subCategory)
                                }
                            }
                        }
                        categoryMenu.append(CategoryMenu(mainCategory: category, subCategories: items))
                    }
                }
            }
        } else if categories.count == 1 { // For parsing subcategories
            let category = categories[0]
            var items = [CategoriesEntity]()
            if let subCategories = category.subCategories {
                for subCategoryId in subCategories as! [Int] {
                    if let subCategory = CoreDataManager.sharedInstance.fetchedCategory(subCategoryId) {
                        items.append(subCategory)
                    }
                }
            }
            categoryMenu.append(CategoryMenu(mainCategory: category, subCategories: items))
        }
    }
}

//
//  BaseModel.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation

// MARK: - BaseModel
class BaseModel: Codable {
    let categories: [Category]
    let rankings: [Ranking]
    
    init(categories: [Category], rankings: [Ranking]) {
        self.categories = categories
        self.rankings = rankings
    }
}

// MARK: - Category
class Category: Codable {
    let id: Int
    let name: String
    let products: [CategoryProduct]
    let childCategories: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, name, products
        case childCategories = "child_categories"
    }
    
    init(id: Int, name: String, products: [CategoryProduct], childCategories: [Int]) {
        self.id = id
        self.name = name
        self.products = products
        self.childCategories = childCategories
    }
}

// MARK: - CategoryProduct
class CategoryProduct: Codable {
    let id: Int
    let name, dateAdded: String
    let variants: [Variant]
    let tax: Tax
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case dateAdded = "date_added"
        case variants, tax
    }
    
    init(id: Int, name: String, dateAdded: String, variants: [Variant], tax: Tax) {
        self.id = id
        self.name = name
        self.dateAdded = dateAdded
        self.variants = variants
        self.tax = tax
    }
}

// MARK: - Tax
class Tax: Codable {
    let name: Name
    let value: Double
    
    init(name: Name, value: Double) {
        self.name = name
        self.value = value
    }
}

enum Name: String, Codable {
    case vat = "VAT"
    case vat4 = "VAT4"
}

// MARK: - Variant
class Variant: Codable {
    let id: Int
    let color: String
    let size: Int?
    let price: Int
    
    init(id: Int, color: String, size: Int?, price: Int) {
        self.id = id
        self.color = color
        self.size = size
        self.price = price
    }
}

// MARK: - Ranking
class Ranking: Codable {
    let ranking: String
    let products: [RankingProduct]
    
    init(ranking: String, products: [RankingProduct]) {
        self.ranking = ranking
        self.products = products
    }
}

// MARK: - RankingProduct
class RankingProduct: Codable {
    let id: Int
    let viewCount, orderCount, shares: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case viewCount = "view_count"
        case orderCount = "order_count"
        case shares
    }
    
    init(id: Int, viewCount: Int?, orderCount: Int?, shares: Int?) {
        self.id = id
        self.viewCount = viewCount
        self.orderCount = orderCount
        self.shares = shares
    }
}

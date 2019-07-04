//
//  CDManager.swift
//  QIoT
//
//  Created by Sunil Targe on 2018/9/26.
//  Copyright © 2018 QNAP. All rights reserved.
//

import CoreData
import Foundation
import UIKit
class CoreDataManager {
    static let sharedInstance = CoreDataManager()
    var managedObjectContext: NSManagedObjectContext?

    private init() {
    }

    // MARK: - Save data to db
    func saveContext() {
        // Check if the view controller managed object context is not nil.
        // Since we are note cleaning this instance, on our case,
        // the guard will always return a valid context.
        // But despite that, let's have the correct way to use a optional variable.
        guard let _context = managedObjectContext else { return }

        if _context.hasChanges {
            do {
                try _context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - Insert data to db
    func insertData(_ baseModel: BaseModel) {
        for category in baseModel.categories {
            if let categoryRecord = insertNewCategory(category: category) {
                for product in category.products {
                    if let productRecord = insertNewProduct(categoryProduct: product) {
                        for variant in product.variants {
                            if let variantRecord = insertNewVariant(variant: variant) {
                                productRecord.addToVariants(variantRecord)
                            }
                        }
                        
                        if let taxRecord = insertNewTax(tax: product.tax) {
                            productRecord.tax = taxRecord
                        }
                        categoryRecord.addToProducts(productRecord)
                    }
                }
                if category.childCategories.count > 0 {
                    categoryRecord.subCategories = category.childCategories as NSObject
                }
            }
        }
        
        for ranking in baseModel.rankings {
            if let rankingRecord = insertNewRanking(ranking: ranking) {
                for rankingProduct in ranking.products {
                    if let productRecord = insertNewRankingProduct(ranking: rankingProduct){
                        rankingRecord.addToProducts(productRecord)
                    }
                }
            }
        }
        
        // Save context
        saveContext()
    }
    
    func insertNewCategory(category: Category) -> CategoriesEntity? {
        let categoryRecord = NSEntityDescription.insertNewObject(forEntityName: "CategoriesEntity", into: managedObjectContext!) as! CategoriesEntity
        categoryRecord.id = Int64(category.id)
        categoryRecord.name = category.name
        return categoryRecord
    }
    
    func insertNewProduct(categoryProduct: CategoryProduct) -> ProductEntity? {
        let productRecord = NSEntityDescription.insertNewObject(forEntityName: "ProductEntity", into: managedObjectContext!) as! ProductEntity
        productRecord.id = Int64(categoryProduct.id)
        productRecord.name = categoryProduct.name
        productRecord.dateAdded = categoryProduct.dateAdded
        return productRecord
    }
    
    func insertNewVariant(variant: Variant) -> VariantEntity? {
        let variantRecord = NSEntityDescription.insertNewObject(forEntityName: "VariantEntity", into: managedObjectContext!) as! VariantEntity
        variantRecord.id = Int64(variant.id)
        variantRecord.color = variant.color
        variantRecord.price = Int32(variant.price)
        variantRecord.size = Int16(variant.size ?? 0) // considered default size to be 0
        return variantRecord
    }
    
    func insertNewTax(tax: Tax) -> TaxEntity? {
        let taxRecord = NSEntityDescription.insertNewObject(forEntityName: "TaxEntity", into: managedObjectContext!) as! TaxEntity
        taxRecord.name = tax.name.rawValue
        taxRecord.value = tax.value
        return taxRecord
    }
    
    func insertNewRanking(ranking: Ranking) -> RankingEntity? {
        let rankingRecord = NSEntityDescription.insertNewObject(forEntityName: "RankingEntity", into: managedObjectContext!) as! RankingEntity
        rankingRecord.name = ranking.ranking
        return rankingRecord
    }
    
    func insertNewRankingProduct(ranking: RankingProduct) -> RankingProductEntity? {
        let rankingProductRecord = NSEntityDescription.insertNewObject(forEntityName: "RankingProductEntity", into: managedObjectContext!) as! RankingProductEntity
        rankingProductRecord.id = Int64(ranking.id)
        rankingProductRecord.orderCount = Int64(ranking.orderCount ?? 0)
        rankingProductRecord.viewCount = Int64(ranking.viewCount ?? 0)
        rankingProductRecord.shares = Int64(ranking.shares ?? 0)
        return rankingProductRecord
    }
    
    // MARK: Fetch data from DB
    func fetchCategories() -> [CategoriesEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoriesEntity")
        return try? managedObjectContext?.fetch(fetchRequest) as? [CategoriesEntity]
    }
    
    func fetchRankings() -> [RankingEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RankingEntity")
        return try? managedObjectContext?.fetch(fetchRequest) as? [RankingEntity]
    }
    
    func fetchProducts() -> [ProductEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        return try? managedObjectContext?.fetch(fetchRequest) as? [ProductEntity]
    }
    
    func fetchVariants() -> [VariantEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VariantEntity")
        return try? managedObjectContext?.fetch(fetchRequest) as? [VariantEntity]
    }
    
    func fetchedCategory(_ categoryId: Int) -> CategoriesEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoriesEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %d", categoryId)
        
        let categories = try? managedObjectContext?.fetch(fetchRequest) as? [CategoriesEntity]
        
        return categories?.first
    }
    
    func fetchRanking(_ rankingName: String) -> RankingEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RankingEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name = %@", rankingName)
        
        let rankings = try? managedObjectContext?.fetch(fetchRequest) as? [RankingEntity]
        
        return rankings?.first
    }
    
    func fetchProducts(forIds: [Int]) -> [ProductEntity]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        fetchRequest.predicate = NSPredicate(format: "id IN %@", forIds)
        
        return try? managedObjectContext?.fetch(fetchRequest) as? [ProductEntity]
    }
}



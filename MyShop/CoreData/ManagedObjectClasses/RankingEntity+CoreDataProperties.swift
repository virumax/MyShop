//
//  RankingEntity+CoreDataProperties.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//
//

import Foundation
import CoreData


extension RankingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RankingEntity> {
        return NSFetchRequest<RankingEntity>(entityName: "RankingEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension RankingEntity {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: ProductEntity)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: ProductEntity)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

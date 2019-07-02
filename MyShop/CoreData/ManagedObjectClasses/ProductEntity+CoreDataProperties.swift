//
//  ProductEntity+CoreDataProperties.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//
//

import Foundation
import CoreData


extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var dateAdded: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var tax: TaxEntity?
    @NSManaged public var variants: NSSet?
    @NSManaged public var category: CategoriesEntity?

}

// MARK: Generated accessors for variants
extension ProductEntity {

    @objc(addVariantsObject:)
    @NSManaged public func addToVariants(_ value: VariantEntity)

    @objc(removeVariantsObject:)
    @NSManaged public func removeFromVariants(_ value: VariantEntity)

    @objc(addVariants:)
    @NSManaged public func addToVariants(_ values: NSSet)

    @objc(removeVariants:)
    @NSManaged public func removeFromVariants(_ values: NSSet)

}

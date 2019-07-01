//
//  Product+CoreDataProperties.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var variants: NSSet?
    @NSManaged public var tax: Tax?

}

// MARK: Generated accessors for variants
extension Product {

    @objc(addVariantsObject:)
    @NSManaged public func addToVariants(_ value: Variant)

    @objc(removeVariantsObject:)
    @NSManaged public func removeFromVariants(_ value: Variant)

    @objc(addVariants:)
    @NSManaged public func addToVariants(_ values: NSSet)

    @objc(removeVariants:)
    @NSManaged public func removeFromVariants(_ values: NSSet)

}

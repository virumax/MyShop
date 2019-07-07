//
//  CartEntity+CoreDataProperties.swift
//  
//
//  Created by Virendra Ravalji on 2019/7/6.
//
//

import Foundation
import CoreData


extension CartEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartEntity> {
        return NSFetchRequest<CartEntity>(entityName: "CartEntity")
    }

    @NSManaged public var product: ProductEntity?
    @NSManaged public var variant: VariantEntity?
    @NSManaged public var tax: TaxEntity?

}

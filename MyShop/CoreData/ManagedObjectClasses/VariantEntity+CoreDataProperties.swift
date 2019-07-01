//
//  VariantEntity+CoreDataProperties.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//
//

import Foundation
import CoreData


extension VariantEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VariantEntity> {
        return NSFetchRequest<VariantEntity>(entityName: "VariantEntity")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: Int64
    @NSManaged public var price: Int32
    @NSManaged public var size: Int16
    @NSManaged public var product: ProductEntity?

}

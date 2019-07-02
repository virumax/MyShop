//
//  TaxEntity+CoreDataProperties.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//
//

import Foundation
import CoreData


extension TaxEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaxEntity> {
        return NSFetchRequest<TaxEntity>(entityName: "TaxEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Double
    @NSManaged public var product: ProductEntity?

}

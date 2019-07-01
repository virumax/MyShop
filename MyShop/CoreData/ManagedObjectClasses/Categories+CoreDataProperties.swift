//
//  Categories+CoreDataProperties.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var hasParent: Bool
    @NSManaged public var subCategories: NSObject?
    @NSManaged public var products: Product?

}

//
//  Variant+CoreDataProperties.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//
//

import Foundation
import CoreData


extension Variant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Variant> {
        return NSFetchRequest<Variant>(entityName: "Variant")
    }

    @NSManaged public var id: Int64
    @NSManaged public var color: String?
    @NSManaged public var size: Int16
    @NSManaged public var price: Int32

}

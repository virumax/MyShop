//
//  Tax+CoreDataProperties.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/1.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//
//

import Foundation
import CoreData


extension Tax {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tax> {
        return NSFetchRequest<Tax>(entityName: "Tax")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Int32

}

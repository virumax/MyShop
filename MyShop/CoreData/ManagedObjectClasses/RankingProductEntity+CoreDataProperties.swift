//
//  RankingProductEntity+CoreDataProperties.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/2.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//
//

import Foundation
import CoreData


extension RankingProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RankingProductEntity> {
        return NSFetchRequest<RankingProductEntity>(entityName: "RankingProductEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var viewCount: Int64
    @NSManaged public var orderCount: Int64
    @NSManaged public var shares: Int64
    @NSManaged public var ranking: RankingEntity?

}

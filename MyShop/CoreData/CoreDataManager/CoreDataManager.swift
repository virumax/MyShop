//
//  CDManager.swift
//  QIoT
//
//  Created by Sunil Targe on 2018/9/26.
//  Copyright © 2018 QNAP. All rights reserved.
//

import CoreData
import Foundation
import UIKit
class CoreDataManager {
    static let sharedInstance = CoreDataManager()
    var managedObjectContext: NSManagedObjectContext?

    private init() {
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        // Check if the view controller managed object context is not nil.
        // Since we are note cleaning this instance, on our case,
        // the guard will always return a valid context.
        // But despite that, let's have the correct way to use a optional variable.
        guard let _context = managedObjectContext else { return }

        if _context.hasChanges {
            do {
                try _context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

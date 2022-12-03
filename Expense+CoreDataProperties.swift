//
//  Expense+CoreDataProperties.swift
//  MageMoney
//
//  Created by Benderson Phanor on 10/8/22.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var type: Int16
    @NSManaged public var currency: Currency?

}

extension Expense : Identifiable {

}

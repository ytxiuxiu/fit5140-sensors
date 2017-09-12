//
//  Colour+CoreDataProperties.swift
//  
//
//  Created by YINGCHEN LIU on 12/9/17.
//
//

import Foundation
import CoreData


extension Colour {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Colour> {
        return NSFetchRequest<Colour>(entityName: "Colour")
    }

    @NSManaged public var r: Double
    @NSManaged public var g: Double
    @NSManaged public var b: Double
    @NSManaged public var addedAt: NSDate?
    @NSManaged public var label: String?

}

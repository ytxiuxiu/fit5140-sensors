//
//  Pressure+CoreDataProperties.swift
//  
//
//  Created by YINGCHEN LIU on 12/9/17.
//
//

import Foundation
import CoreData


extension Pressure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pressure> {
        return NSFetchRequest<Pressure>(entityName: "Pressure")
    }

    @NSManaged public var addedAt: NSDate?
    @NSManaged public var temperature: Double
    @NSManaged public var pressure: Double
    @NSManaged public var altitude: Double
    @NSManaged public var label: String?

}

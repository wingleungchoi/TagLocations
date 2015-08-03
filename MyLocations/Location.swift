//
//  Location.swift
//  
//
//  Created by Wing LeungCHOI on 3/8/15.
//
//

import Foundation
import CoreData
import CoreLocation

class Location: NSManagedObject {

    @NSManaged var latitude: Double
    @NSManaged var date: NSDate
    @NSManaged var longitude: Double
    @NSManaged var locationDescription: String
    @NSManaged var category: String
    @NSManaged var placemark: CLPlacemark?

}

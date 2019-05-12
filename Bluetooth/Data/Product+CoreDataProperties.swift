//
//  Product+CoreDataProperties.swift
//  Bluetooth
//
//  Created by Julian Avila Polanco on 5/5/19.
//  Copyright © 2019 Julian Avila Polanco. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var image: NSData?

}

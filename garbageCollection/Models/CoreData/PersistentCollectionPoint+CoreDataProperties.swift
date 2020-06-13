//
//  PersistentCollectionPoint+CoreDataProperties.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-05-21.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//
//

import Foundation
import CoreData

extension PersistentCollectionPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistentCollectionPoint> {
        return NSFetchRequest<PersistentCollectionPoint>(entityName: "PersistentCollectionPoint")
    }

    @NSManaged public var address: String?
    @NSManaged public var bairro: String?
    @NSManaged public var hours: String?
    @NSManaged public var identifier: String?
    @NSManaged public var location: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var regional: String?
    @NSManaged public var source: String?
    @NSManaged public var type: String?
    @NSManaged public var year: String?

    public override var description: String {
        "\(name) - \(type)"
    }
}

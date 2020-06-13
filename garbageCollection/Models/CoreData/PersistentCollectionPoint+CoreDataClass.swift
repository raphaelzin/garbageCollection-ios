//
//  PersistentCollectionPoint+CoreDataClass.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-05-21.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation
import Parse

@objc(PersistentCollectionPoint)
public class PersistentCollectionPoint: NSManagedObject {
    
    convenience init(remoteCollectionPoint: CollectionPoint, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "PersistentCollectionPoint", in: context)!
        self.init(entity: entity, insertInto: context)
        
        address = remoteCollectionPoint.address
        bairro = remoteCollectionPoint.bairro
        hours = remoteCollectionPoint.hours
        identifier = remoteCollectionPoint.identifier
        name = remoteCollectionPoint.name
        phone = remoteCollectionPoint.phone
        regional = remoteCollectionPoint.regional
        source = remoteCollectionPoint.source
        location = remoteCollectionPoint.location
//        type = remoteCollectionPoint.safeType.
        year = remoteCollectionPoint.yearRef
    }
    
}

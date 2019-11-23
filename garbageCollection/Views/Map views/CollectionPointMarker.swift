//
//  CollectionPointMarker.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-05.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import MapKit

class CollectionPointMarker: NSObject, MKAnnotation {
    
    let collectionPoint: CollectionPoint
    
    var title: String? {
        return collectionPoint.name ?? "Ponto de coleta"
    }
    
    var coordinate: CLLocationCoordinate2D {
        collectionPoint.location?.CLCoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
  
    init(collectionPoint: CollectionPoint) {
        self.collectionPoint = collectionPoint
        super.init()
    }
    
}

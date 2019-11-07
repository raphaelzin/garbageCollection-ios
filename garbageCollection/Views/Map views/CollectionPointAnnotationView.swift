//
//  CollectionPointAnnotationView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-05.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import MapKit
import UIKit

class CollectionPointAnnotationView: MKMarkerAnnotationView {
    
    static let reuseIdentifier = "CollectionPointAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let type = (annotation as? CollectionPointMarker)?.collectionPoint.safeType {
            self.markerTintColor = type.tintColor
            self.glyphImage = type.icon
            self.glyphTintColor = .white
        }
    }
    
    convenience init(annotation: MKAnnotation?) {
        self.init(annotation: annotation, reuseIdentifier: CollectionPointAnnotationView.reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

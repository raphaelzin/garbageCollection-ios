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
    
//    override var annotation: MKAnnotation? {
//        willSet {
//          // 1
//          guard let artwork = newValue as? Artwork else { return }
//          canShowCallout = true
//          calloutOffset = CGPoint(x: -5, y: 5)
//          rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//          // 2
//          markerTintColor = artwork.markerTintColor
//          glyphText = String(artwork.discipline.first!)
//        }
//      }
//    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let type = (annotation as? CollectionPointMarker)?.collectionPoint.safeType {
//            self.image = type.icon
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

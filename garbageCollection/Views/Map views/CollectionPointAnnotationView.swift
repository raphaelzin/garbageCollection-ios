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
            markerTintColor = type.tintColor
            
            let widthHeightRatio = type.icon.size.width/type.icon.size.height
            let size = CGSize(width: 80, height: 80/widthHeightRatio)
            
            let renderer = UIGraphicsImageRenderer(size: size)

            let image = renderer.image { _ in
                let padding: CGFloat = 16
                let paddingSize = CGSize(width: size.width - padding, height: size.height - padding)
                let offsetOrigin = CGPoint(x: padding/2, y: padding/2)
                type.icon.draw(in: CGRect(origin: offsetOrigin, size: paddingSize))
            }
            
            glyphImage = image
            glyphTintColor = .white
        }
    }
    
    convenience init(annotation: MKAnnotation?) {
        self.init(annotation: annotation, reuseIdentifier: CollectionPointAnnotationView.reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

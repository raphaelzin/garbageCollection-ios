//
//  CollectionPointDescription.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-31.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

struct CollectionPointDescription: Decodable {
    
    let data: [CollectionPointDescriptionElement]
    
    var attributedString: NSAttributedString? {
        guard !data.isEmpty else { return nil }
        let description = NSMutableAttributedString()
        
        data.forEach { (element) in
            description.append(element.attributedString)
        }
        
        return description
    }
    
    enum CodingKeys: String, CodingKey {
        case data = "description"
    }
    
}

struct CollectionPointDescriptionElement: Decodable {
    
    var type: ElementType
    var value: String
    
    var attributedString: NSAttributedString {
        NSAttributedString(string: value, attributes: type.attributes)
    }
    
    enum CodingKeys: String, CodingKey { case type, value }
    
    enum ElementType: String, Decodable {
        case header, paragraph
        
        var attributes: [NSAttributedString.Key: Any] {
            switch self {
            case .header:
                return [.foregroundColor: UIColor.label,
                        .font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
            case .paragraph:
                return [.foregroundColor: UIColor.gray,
                        .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
            }
        }
        
    }
    
}

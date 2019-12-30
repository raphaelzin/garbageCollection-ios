//
//  CollectionPoint.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse

class CollectionPoint: PFObject, PFSubclassing {
    
    @NSManaged var bairro: String?
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var yearRef: String?
    @NSManaged var source: String?
    @NSManaged var regional: String?
    @NSManaged var location: PFGeoPoint?
    
    @NSManaged private var type: String?
    
    var safeType: PointType? {
        get { PointType(rawValue: type ?? "") }
        set { type = newValue?.rawValue }
    }
    
    static func parseClassName() -> String { return "CollectionPoint" }
    
}

// MARK: Subtypes

extension CollectionPoint {
    
    enum PointType: String, CaseIterable {
        case ecopoint
        case association
        case pev = "PEV"
        case pcee = "PCEE"
        case ogr = "OGR"
        
        var shortName: String {
            switch self {
            case .ecopoint: return "Ecoponto"
            case .association: return "Associação"
            case .pev, .pcee, .ogr: return self.rawValue
            }
        }
            
        var fullName: String {
            switch self {
            case .ecopoint: return "Ecoponto"
            case .association: return "Associação"
            case .pcee: return "Ponto de coleta de eletro-eletrônicos"
            case .pev: return "Ponto de entrega voluntária"
            case .ogr: return "Pontos de coleta de Óleo e gordura residual"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .ecopoint: return #imageLiteral(resourceName: "ecoponto-icon")
            case .association: return #imageLiteral(resourceName: "association-icon")
            case .pcee: return #imageLiteral(resourceName: "eletronic-icon")
            case .pev: return #imageLiteral(resourceName: "voluntary-icon")
            case .ogr: return #imageLiteral(resourceName: "oil-icon")
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .association: return .skyBlue
            case .ecopoint: return .coolGreen
            case .pcee: return .coolGreen
            case .pev: return .orangeyRed
            case .ogr: return .marigold
            }
        }
    }
}

// MARK: Properties

extension CollectionPoint {
    
    struct Properties {
        static let bairro = "bairro"
        static let identifier = "identifier"
        static let name = "name"
        static let address = "address"
        static let yearRef = "yearRef"
        static let source = "source"
        static let regional = "regional"
        static let location = "location"
    }
    
}

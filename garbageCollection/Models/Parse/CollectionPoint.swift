//
//  CollectionPoint.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse

protocol XCollectionPoint {
    var bairro: String? { get }
    var identifier: String? { get }
    var name: String? { get }
    var address: String? { get }
    var yearRef: String? { get }
    var source: String? { get }
    var regional: String? { get }
    var phone: String? { get }
    var hours: String? { get }
    var location: PFGeoPoint? { get }
    var listedDetails: [CollectionPoint.DetailsListingType] { get }
}

class CollectionPoint: PFObject, PFSubclassing {
    
    @NSManaged var bairro: String?
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var yearRef: String?
    @NSManaged var source: String?
    @NSManaged var regional: String?
    @NSManaged var phone: String?
    @NSManaged var hours: String?
    @NSManaged var location: PFGeoPoint?
    
    @NSManaged private var type: String?
    
    var safeType: PointType? {
        get { PointType(rawValue: type ?? "") }
        set { type = newValue?.rawValue }
    }
    
    var listedDetails: [DetailsListingType] {
        var details = [DetailsListingType]()
        
        if let address = address {
            details.append(.address(address))
        }
        
        if let phone = phone {
            details.append(.phone(phone))
        }
        
        if let hours = hours {
            details.append(.hours(hours))
        }
        
        return details
    }
    
    static func parseClassName() -> String { return "CollectionPoint" }
    
}

// MARK: Helper methods

extension CollectionPoint {
    
    enum DetailsListingType {
        case address(String)
        case phone(String)
        case hours(String)
        
        var title: String {
            switch self {
            case .address: return "Endereço"
            case .hours: return "Horário"
            case .phone: return "Telefone"
            }
        }
        
        var details: String {
            switch self {
            case .address(let address): return address
            case .hours(let hours): return hours
            case .phone(let phoneNumber): return phoneNumber
            }
        }
        
        var action: DetailsAction? {
            switch self {
            case .phone: return .call
            case .address: return .route
            default: return nil
            }
        }
        
        enum DetailsAction {
            case call, route
            
            var icon: UIImage? {
                switch self {
                case .call: return #imageLiteral(resourceName: "phone-icon")
                case .route: return #imageLiteral(resourceName: "map-icon")
                }
            }
        }
    }
    
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
            case .pcee: return .eletronicCyan
            case .pev: return .orangeyRed
            case .ogr: return .marigold
            }
        }
    }
}

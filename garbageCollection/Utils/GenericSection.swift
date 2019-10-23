//
//  GenericSection.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-21.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import RxDataSources
import RxSwift

// Data source Sections

struct GenericSection<Item: IdentifiableType & Equatable> {
    var items: [Item]
    var header: String
}

extension GenericSection: SectionModelType {
    init(original: GenericSection<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}

extension GenericSection: AnimatableSectionModelType {
    typealias Identity = String
    
    var identity: String { return header }
}

//
//  CollectionPointMoreInfoViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-31.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CollectionPointMoreInfoViewModelType: class {
    var descriptionContent: Observable<NSAttributedString?> { get }
    var collectionPointType: CollectionPoint.PointType { get }
}

class CollectionPointMoreInfoViewModel: CollectionPointMoreInfoViewModelType {
    
    // MARK: Attributes
    
    private let descriptionContentRelay = BehaviorRelay<NSAttributedString?>(value: nil)
    
    let collectionPointType: CollectionPoint.PointType
    
    var descriptionContent: Observable<NSAttributedString?> {
        descriptionContentRelay.asObservable()
    }
    
    // MARK: Lifecycle
    
    init(type: CollectionPoint.PointType) {
        self.collectionPointType = type
        fetchDescription()
    }
    
}

private extension CollectionPointMoreInfoViewModel {
    
    func fetchDescription() {
        let baseURL = Environment.getValue(forKey: .serverBaseURL)
        let api = "/api/"
        let queryParam = "getCollectionPointDescription?type=" + collectionPointType.rawValue
        let rawUrl = baseURL + api + queryParam
        
        guard let url = URL(string: rawUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data, let content = try? JSONDecoder().decode(CollectionPointDescription.self, from: data) else {
                return
            }
            
            self?.descriptionContentRelay.accept(content.attributedString)
        }
        
        task.resume()
    }
    
}

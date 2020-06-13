//
//  CollectionPointsManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-05.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse
import RxSwift
import CoreData

class CollectionPointsManager {
    
    let managedContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext? = nil) {
        if let context = context {
            managedContext = context
        } else {
            let stack = CoreDataStack(modelName: "GarbageCollectionDataModel")
            managedContext = stack.managedContext
        }
    }
    
    func collectionPoints() -> Single<[CollectionPoint]> {
        let colletionPointsFetch: NSFetchRequest<PersistentCollectionPoint> = PersistentCollectionPoint.fetchRequest()
        
        do {
            let results = try self.managedContext.fetch(colletionPointsFetch)
            print(results)
            return .just([])
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        return .error(GCError.Server.noDataFound)
    }
    
    func parseSync() -> Completable {
        fetchRemoteCollectionPoints().flatMap { (collectionPoints) -> Single<[Bool]> in
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PersistentCollectionPoint")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let stack = CoreDataStack(modelName: "GarbageCollectionDataModel")
            stack.delete(request: deleteRequest)
            
            collectionPoints.forEach { cp in
                _ = PersistentCollectionPoint(remoteCollectionPoint: cp, context: self.managedContext)
            }
            
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Save error: \(error) description: \(error.userInfo)")
            }
            
            return .just([true])
        }.asCompletable()
    }
    
    func fetchRemoteCollectionPoints() -> Single<[CollectionPoint]> {
        guard let query = CollectionPoint.query() else { return .error(GCError.Misc.invalidquery) }

        return query.rx.findObjects().map { (result) -> [CollectionPoint] in
            if let collectionSchedule = result as? [CollectionPoint] {
                return collectionSchedule
            } else {
                throw GCError.Server.invalidQueryResult
            }
        }.asSingle()
    }
    
}

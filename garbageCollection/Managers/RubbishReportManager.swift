//
//  RubbishReportManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-01.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift

protocol RubbishReportManagerProtocol: class {
    func reportRubbish(location: Location, date: Date, details: String?, picture: UIImage?) -> Completable
}

class RubbishReportManager: RubbishReportManagerProtocol {
    
    func reportRubbish(location: Location, date: Date, details: String?, picture: UIImage?) -> Completable {
        let report = RubbishReport(location: location)
        report.seenTimestamp = date
        report.comment = details
        report.picture = PFFileImageHelper.pffile(for: picture?.resized(to: .init(width: 1000, height: 1000)),
                                                  compressionQuality: 0.5)
        
        return report
            .rx
            .save()
            .asSingle()
            .asCompletable()
    }
    
}

//
//  RubbishReportManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-01.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift

class RubbishReportManager {
    
    func reportRubbish(location: Location, date: Date, details: String?, picture: UIImage) -> Completable {
        let report = RubbishReport(location: location)
        report.seenTimestamp = date
        report.comment = details
        report.picture = PFFileImageHelper.pffile(for: picture, compressionQuality: 0.3)
        
        return report
            .rx
            .save()
            .asSingle()
            .asCompletable()
    }
    
}

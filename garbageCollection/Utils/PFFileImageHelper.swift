//
//  PFFileImageHelper.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-01.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import Parse
import RxSwift

class PFFileImageHelper {
    static func image(from pffile: PFFileObject?, size: CGSize? = nil) -> Single<UIImage?> {
        guard let pffile = pffile else { return .just(nil) }
        return pffile
            .rx
            .getData()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .map { (data) -> UIImage? in
                if let size = size {
                    return UIImage(data: data)?.resized(to: size)
                }
                return UIImage(data: data)
            }
            .asSingle()
            .observeOn(MainScheduler.asyncInstance)
        
    }
    
    static func pffile(for image: UIImage?, compressionQuality: CGFloat = 0.5) -> PFFileObject? {
        guard let data: Data = image?.jpegData(compressionQuality: compressionQuality) else { return nil }
        return PFFileObject(name: "generic_pffile.jpg", data: data)
    }
}

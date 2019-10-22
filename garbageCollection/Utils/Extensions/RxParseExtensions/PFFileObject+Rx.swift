//
//  PFFileObject+Rx.swift
//  Parse+RxSwift
//
//  Created by Raphael on 2019-04-08.
//  Copyright © 2019 Guarana Technologies Inc. All rights reserved.
//

import RxSwift
import Parse

extension Reactive where Base: PFFileObject {
    public func save() -> Observable<Bool> {
        return createWithParseCallback({ observer in
            self.base.saveInBackground(block: ParseRxCallbacks.rx_parseCallback(observer))
        })
    }
    
    public func saveWithProgress() -> Observable<Int32> {
        return createWithParseCallback({ observer in
            self.base.saveInBackground(progressBlock: { (progress) in
                observer.onNext(progress)
                if progress > 99 { observer.onCompleted() }
            })
        })
    }
    
    public func getData() -> Observable<Data> {
        return createWithParseCallback({ observer in
            self.base.getDataInBackground(block: ParseRxCallbacks.rx_parseUnwrappedOptionalCallback(observer))
        })
    }
    
    public func getDataStream() -> Observable<InputStream> {
        return createWithParseCallback({ observer in
            self.base.getDataStreamInBackground(block: ParseRxCallbacks.rx_parseUnwrappedOptionalCallback(observer))
        })
    }
}

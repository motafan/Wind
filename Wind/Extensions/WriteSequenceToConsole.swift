//
//  WriteSequenceToConsole.swift
//  Wind
//
//  Created by tanfanfan on 2017/5/3.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension ObservableType {
    
    /**
     Add observer with `id` and print each emitted event.
     - parameter id: an identifier for the subscription.
     */
    func addObserver(_ id: String) -> Disposable {
        return subscribe { debugPrint("Subscription:", id, "Event:", $0) }
    }
    
}


extension SharedSequenceConvertibleType where Self.SharingStrategy == RxCocoa.DriverSharingStrategy {

    func addDriver(_ id: String) -> Disposable {
        return self.asObservable().addObserver(id)
    }

}

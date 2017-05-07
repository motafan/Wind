//
//  Pagination.swift
//  Wind
//
//  Created by tanfanfan on 2017/2/7.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation

public struct Pagination<T> {
    let items: [T]
    let hasNext: Bool
}

extension Pagination: Decodable {
    public static func parse(data: Data) -> Pagination? {
        return nil
    }
}

public struct NextPageState<T> {
    public private(set) var hasNext: Bool
    public fileprivate(set) var isLoading: Bool
    public private(set) var lastId: T?
    public init() {
        hasNext = true
        isLoading = false
        lastId = nil
    }
    public mutating func reset() {
        hasNext = true
        isLoading = false
        lastId = nil
    }
    public mutating func update(hasNext: Bool, isLoading: Bool, lastId: T?) {
        self.hasNext = hasNext
        self.isLoading = isLoading
        self.lastId = lastId
    }
}

public protocol NextPageLoadable: class {
    associatedtype DataType
    associatedtype LastIdType
    var data: [DataType] { get set }
    var nextPageState: NextPageState<LastIdType> { get set }
    func performLoad(
        successHandler: @escaping (_ rows: [DataType],
        _ hasNext: Bool,
        _ lastId: LastIdType?) -> (),
        failHandler: @escaping () -> ()
    )
}

extension NextPageLoadable {
    func loadNext(reloadView: ReloadableType) {
        guard nextPageState.hasNext else { return }
        if nextPageState.isLoading { return }
        nextPageState.isLoading = true
        performLoad(successHandler: { (rows, hasNext, lastId) in
            self.data += rows
            self.nextPageState.update(hasNext: hasNext,
                                      isLoading: false,
                                      lastId: lastId)
            
            let object = self
            let userInfo = [NextPageLoadableReloadViewUserInfoKey : object]
            let notificationCenter: NotificationCenter = .default
            //reload view will reload data
            notificationCenter.post(name: .NextPageLoadableWillReloadData,
                                    object: object,
                                    userInfo: userInfo)
            reloadView.reloadData()
            //reload view did reload data
            notificationCenter.post(name: .NextPageLoadableDidReloadData,
                                    object: object,
                                    userInfo: userInfo)
        }, failHandler: {
            // Failed when first loading
            if self.nextPageState.lastId == nil {
                self.data = []
                self.nextPageState.reset()
            }
        })
    }
}

public let NextPageLoadableReloadViewUserInfoKey: String
    = "NextPageLoadableReloadViewUserInfoKey"

public extension Notification.Name {
    
    // userInfo dictionary key for reloadView reload data
    public static let NextPageLoadableWillReloadData: Notification.Name = .init("NextPageLoadableWillReloadData")
    // userInfo contains reload view
    
    public static let NextPageLoadableDidReloadData: Notification.Name = .init("NextPageLoadableDidReloadData")
    //  userInfo contains reload view with ReloadableType type
}

//
//  Request.swift
//  Page
//
//  Created by tanfanfan on 2017/2/6.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
}

public protocol Decodable {
    static func parse(data: Data) -> Self?
}

public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: AnyObject] { get }
    associatedtype Response: Decodable
}

public extension Request {
    var parameter: [String: AnyObject] {
        return [:]
    }
}

public protocol Client {
    var host: String { get }
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void)
}

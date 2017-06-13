//
//  URLSessionClient.swift
//  Wind
//
//  Created by tanfanfan on 2017/2/7.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation

public struct URLSessionClient: Client {
    public let host = "https://api.wind.com"
    
    public func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        
        // 在示例中我们不需要 `httpBody`，实践中可能需要将 parameter 转为 data
        // request.httpBody = ...
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data, let res = T.Response.parse(data: data) {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

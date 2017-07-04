
//
//  User.swift
//  Wind
//
//  Created by tanfanfan on 2017/1/18.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import UIKit

struct User: Codable {
    let name: String
    let message: String
    let id: Int
    init?(data: Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
            return nil
        }
        guard let name = obj?["name"] as? String,
            let message = obj?["message"] as? String,
            let id = obj?["id"] as? Int else {
            return nil
        }
        
        self.name = name
        self.message = message
        self.id = id
    }
}

extension User: Decodable {
    static func parse(data: Data) -> User? {
        let json =  JSONDecoder()
        return try? json.decode(self, from: data)
    }
}





    

    



                              


//
//  User.swift
//  Wind
//
//  Created by tanfanfan on 2017/1/18.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import UIKit

struct User {
    let name: String
    let message: String
    let id: Int
    init?(data: Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
            return nil
        }
        guard let name = obj?["name"] as? String else {
            return nil
        }
        guard let message = obj?["message"] as? String else {
            return nil
        }
        
        guard let id = obj?["id"] as? Int else {
            return nil
        }
        
        self.name = name
        self.message = message
        self.id = id
    }
}


extension User: Decodable {
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}





    

    



                              

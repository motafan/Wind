//
//  UserRequest.swift
//  Wind
//
//  Created by tanfanfan on 2017/2/7.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import Foundation


struct UserResquest: Request {
    typealias Response = Pagination<User>
    var path: String = "users"
    var method: HTTPMethod = .get
    var lastId: Int?
}

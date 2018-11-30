//
//  Models.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct User {
    let name: String
    let username: String
}

struct Comment {
    
}

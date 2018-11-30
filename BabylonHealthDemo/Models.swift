//
//  Models.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let name: String
    let username: String
    let posts: [Post]
}

struct Post {
    let id: Int
    let title: String
    let body: String
    let comments: [Comment]
}

struct Comment {
    let id: Int
    let name: String
    let body: String
}

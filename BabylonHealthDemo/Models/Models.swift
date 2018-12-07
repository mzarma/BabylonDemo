//
//  Models.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct User: Equatable {
    let id: Int
    let name: String
    let username: String
    let posts: [Post]
}

struct Post: Equatable {
    let id: Int
    let title: String
    let body: String
    let comments: [Comment]
}

struct Comment: Equatable {
    let id: Int
    let name: String
    let body: String
}

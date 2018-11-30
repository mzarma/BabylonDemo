//
//  RemoteModels.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct RemoteUser {
    let id: Int
    let name: String
    let username: String
}

struct RemotePost {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct RemoteComment {
    let postId: Int
    let id: Int
    let name: String
    let body: String
}

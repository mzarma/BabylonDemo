//
//  LocalModels.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 02/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct LocalUser {
    let id: Int
    let name: String
    let username: String
    let posts: [LocalPost]
}

struct LocalPost {
    let id: Int
    let title: String
    let body: String
    let comments: [LocalComment]
}

struct LocalComment {
    let id: Int
    let name: String
    let body: String
}

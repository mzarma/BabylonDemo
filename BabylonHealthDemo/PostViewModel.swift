//
//  PostViewModel.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct PostViewModel {
    let post: Post
    
    var title: String {
        return post.title
    }
}

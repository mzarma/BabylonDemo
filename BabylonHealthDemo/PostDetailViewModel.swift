//
//  PostDetailViewModel.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct PostDetailViewModel {
    let post: Post
    let user: User
    
    var author: String {
        return user.username
    }
    
    var description: String {
        return post.body
    }
    
    var numberOfComments: String {
        return String(post.comments.count)
    }
    
    static let authorTitle = "Author"
    static let descriptionTitle = "Description"
    static let numberOfCommentsTitle = "Comments"
}

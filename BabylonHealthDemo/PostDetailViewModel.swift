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
    let users: [User]
    
    var title: String {
        return post.title
    }
    
    var author: String {
        return users.filter({ user in
            return !user.posts.filter({ post in
                return post.id == self.post.id
            }).isEmpty
        }).first?.name ?? ""
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

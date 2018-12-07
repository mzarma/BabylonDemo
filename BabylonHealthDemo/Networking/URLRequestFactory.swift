//
//  URLRequestFactory.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class URLRequestFactory {
    private static let baseURLString = "http://jsonplaceholder.typicode.com"
    private static let postsPath = "/posts"
    private static let usersPath = "/users"
    private static let commentsPath = "/comments"
    
    private static func getRequest(path: String) -> URLRequest {
        var components = URLComponents(string: baseURLString)!
        components.path = path
        return URLRequest(url: components.url!)
    }
    
    static func getPosts() -> URLRequest {
        return getRequest(path: postsPath)
    }

    static func getUsers() -> URLRequest {
        return getRequest(path: usersPath)
    }

    static func getComments() -> URLRequest {
        return getRequest(path: commentsPath)
    }
}

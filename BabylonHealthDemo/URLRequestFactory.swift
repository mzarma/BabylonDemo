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
    
    static func getPosts() -> URLRequest {
        var components = URLComponents(string: baseURLString)!
        components.path = postsPath
        return URLRequest(url: components.url!)
    }
}

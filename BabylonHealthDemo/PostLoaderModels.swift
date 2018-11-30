//
//  PostLoaderModels.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum PostsLoaderError {
    case APIError
    case remoteMappingError
}

enum PostsLoaderResult {
    case success([Post])
    case error(PostsLoaderError)
}

//
//  RemotePostsLoader.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 29/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum PostsLoaderError {
    case APIError
    case remoteMappingError
}

enum PostsLoaderResult {
    case success([Post])
    case error(PostsLoaderError)
}

protocol PostsLoader {
    func loadPosts(completion: @escaping (PostsLoaderResult) -> Void)
}

final class RemotePostsLoader: PostsLoader {
    private let client: APIClient
    private let request: URLRequest
    
    init(client: APIClient, request: URLRequest) {
        self.client = client
        self.request = request
    }
    
    func loadPosts(completion: @escaping (PostsLoaderResult) -> Void) {
        client.execute(request: request) { result in
            switch result {
            case .success(let data):
                guard let posts = RemotePostsLoader.map(data: data) else {
                    return completion(.error(.remoteMappingError))
                }
                completion(.success(posts))
            case .error(_): completion(.error(.APIError))
            }
        }
    }
    
    static private func map(data: Data) -> [Post]? {
        let decoder = JSONDecoder()
        guard let posts = try? decoder.decode([Post].self, from: data) else {
            return nil
        }
        
        return posts
    }
}

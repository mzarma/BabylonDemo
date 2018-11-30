//
//  RemotePostsLoader.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 29/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class RemotePostsLoader: PostsLoader {
    private let client: APIClient
    private let getPostsRequest: URLRequest
    private let getUsersRequest: URLRequest
    private let getCommentsRequest: URLRequest
    
    init(client: APIClient,
         getPostsRequest: URLRequest,
         getUsersRequest: URLRequest,
         getCommentsRequest: URLRequest) {
        self.client = client
        self.getPostsRequest = getPostsRequest
        self.getUsersRequest = getUsersRequest
        self.getCommentsRequest = getCommentsRequest
    }
    
    func loadPosts(completion: @escaping (PostsLoaderResult) -> Void) {
//        client.execute(request: request) { result in
//            switch result {
//            case .success(let data):
//                guard let posts = RemotePostsLoader.map(data: data) else {
//                    return completion(.error(.remoteMappingError))
//                }
//                completion(.success(posts))
//            case .error(_): completion(.error(.APIError))
//            }
//        }
    }
    
    private func map(
        posts: [RemotePost],
        users: [RemoteUser],
        comments: [RemoteComment]) -> [Post] {
        return [Post]()
    }
    
    static private func map(data: Data) -> [Post]? {
//        let decoder = JSONDecoder()
//        guard let posts = try? decoder.decode([Post].self, from: data) else {
//            return nil
//        }
//
//        return posts
        return nil
    }
}

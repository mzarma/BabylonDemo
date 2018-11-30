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
    
    init(client: APIClient) {
        self.client = client
    }
    
    func loadPosts(completion: @escaping (PostsLoaderResult) -> Void) {
        var posts: [RemotePost]?
        var users: [RemoteUser]?
        var comments: [RemoteComment]?
        
        let group = DispatchGroup()
        
        load(URLRequestFactory.getPosts(), group, RemotePostsLoader.mapPosts) { mappedPosts in
            posts = mappedPosts as? [RemotePost]
        }
        
        load(URLRequestFactory.getUsers(), group, RemotePostsLoader.mapUsers) { mappedUsers in
            users = mappedUsers as? [RemoteUser]
        }

        load(URLRequestFactory.getComments(), group, RemotePostsLoader.mapComments) { mappedComments in
            comments = mappedComments as? [RemoteComment]
        }
        
        switch group.wait(timeout: .now() + 10) {
        case .success:
            guard let posts = posts,
                  let users = users,
                  let comments = comments else { return completion(.error(.remote)) }
            return completion(.success(
                RemotePostsLoader.map(posts: posts, users: users, comments: comments)
            ))
        case .timedOut: completion(.error(.remote))
        }
    }
    
    private func load(_ request: URLRequest, _ group: DispatchGroup, _ mapping: @escaping (Data) -> Any?, completion: @escaping (Any) -> Void) {
        group.enter()
        client.execute(request: request) { result in
            switch result {
            case .success(let data):
                guard let remoteDataMapped = mapping(data) else {
                    return group.leave()
                }
                completion(remoteDataMapped)
                group.leave()
            case .error(_):
                group.leave()
            }
        }
    }
}

private extension RemotePostsLoader {
    static func mapPosts(postsData: Data) -> [RemotePost]? {
        guard let posts = try? JSONDecoder().decode([RemotePost].self, from: postsData) else {
            return nil
        }
        
        return posts
    }
    
    static func mapUsers(usersData: Data) -> [RemoteUser]? {
        guard let posts = try? JSONDecoder().decode([RemoteUser].self, from: usersData) else {
            return nil
        }
        
        return posts
    }
    
    static private func mapComments(commentsData: Data) -> [RemoteComment]? {
        guard let posts = try? JSONDecoder().decode([RemoteComment].self, from: commentsData) else {
            return nil
        }
        
        return posts
    }
}

private extension RemotePostsLoader {
    static func map(
        posts: [RemotePost],
        users: [RemoteUser],
        comments: [RemoteComment]) -> [Post] {
        
        let posts: [Post] = posts.map {
            let id = $0.id
            return Post(
                id: id,
                title: $0.title,
                body: $0.body,
                comments: comments
                    .filter { $0.postId == id }
                    .map {
                        return Comment(id: $0.id, name: $0.name, body: $0.name)
                }
            )
        }
        
        return posts
    }
}

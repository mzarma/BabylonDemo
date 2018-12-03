//
//  RemoteDataLoader.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 29/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class RemoteDataLoader: DataLoader {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func loadData(completion: @escaping (DataLoaderResult) -> Void) {
        var posts: [RemotePost]?
        var users: [RemoteUser]?
        var comments: [RemoteComment]?
        
        let group = DispatchGroup()
        
        load(URLRequestFactory.getPosts(), group, RemoteDataLoader.mapPosts) { mappedPosts in
            posts = mappedPosts as? [RemotePost]
        }
        
        load(URLRequestFactory.getUsers(), group, RemoteDataLoader.mapUsers) { mappedUsers in
            users = mappedUsers as? [RemoteUser]
        }

        load(URLRequestFactory.getComments(), group, RemoteDataLoader.mapComments) { mappedComments in
            comments = mappedComments as? [RemoteComment]
        }
        
        switch group.wait(timeout: .now() + 10) {
        case .success:
            guard let posts = posts,
                  let users = users,
                  let comments = comments else { return completion(.error(.remote)) }
            return completion(.success(
                RemoteDataLoader.map(remotePosts: posts, remoteUsers: users, remoteComments: comments)
            ))
        case .timedOut: completion(.error(.remote))
        }
    }
    
    private func load(_ request: URLRequest, _ group: DispatchGroup, _ mapping: @escaping (Data) -> Any?, completion: @escaping (Any) -> Void) {
        group.enter()
        client.execute(request) { result in
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

private extension RemoteDataLoader {
    static func mapPosts(data: Data) -> [RemotePost]? {
        guard let posts = try? JSONDecoder().decode([RemotePost].self, from: data) else {
            return nil
        }
        
        return posts
    }
    
    static func mapUsers(data: Data) -> [RemoteUser]? {
        guard let users = try? JSONDecoder().decode([RemoteUser].self, from: data) else {
            return nil
        }
        
        return users
    }
    
    static private func mapComments(data: Data) -> [RemoteComment]? {
        guard let comments = try? JSONDecoder().decode([RemoteComment].self, from: data) else {
            return nil
        }
        
        return comments
    }
}

private extension RemoteDataLoader {
    static func map(
        remotePosts: [RemotePost],
        remoteUsers: [RemoteUser],
        remoteComments: [RemoteComment]) -> [User] {
        
        let users: [User] = remoteUsers.map {
            let userId = $0.id
            return User(
                id: userId,
                name: $0.name,
                username: $0.username,
                posts: remotePosts
                    .filter { $0.userId == userId }
                    .map {
                        let postId = $0.id
                        return Post(id: $0.id,
                                    title: $0.title,
                                    body: $0.body,
                                    comments: remoteComments
                                        .filter { $0.postId == postId }
                                        .map {
                                            return Comment(id: $0.id, name: $0.name, body: $0.name)
                                        }
                                    )
                    }
            )
        }

        return users
    }
}

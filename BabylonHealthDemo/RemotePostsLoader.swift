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
        var posts: [RemotePost]?
        var users: [RemoteUser]?
        var comments: [RemoteComment]?
        
        let group = DispatchGroup()
        
        group.enter()
        client.execute(request: getPostsRequest) { result in
            switch result {
            case .success(let data):
                guard let remotePosts = RemotePostsLoader.map(postsData: data) else {
                    group.leave()
                    return
                }
                posts = remotePosts
                group.leave()
            case .error(_):
                group.leave()
            }
        }
        
        group.enter()
        client.execute(request: getUsersRequest) { result in
            switch result {
            case .success(let data):
                guard let remoteUsers = RemotePostsLoader.map(usersData: data) else {
                    group.leave()
                    return
                }
                users = remoteUsers
                group.leave()
            case .error(_):
                group.leave()
            }
        }
            
        group.enter()
        client.execute(request: getCommentsRequest) { result in
            switch result {
            case .success(let data):
                guard let remoteComments = RemotePostsLoader.map(commentsData: data) else {
                    group.leave()
                    return
                }
                comments = remoteComments
                group.leave()
            case .error(_):
                group.leave()
            }
        }
        
        switch group.wait(timeout: .now() + 10) {
        case .success:
            guard let posts = posts,
                  let users = users,
                let comments = comments else { return completion(.error(.remote)) }
            return completion(.success(RemotePostsLoader.map(posts: posts, users: users, comments: comments)))
        case .timedOut: completion(.error(.remote))
        }
    }
    
    static private func map(
        posts: [RemotePost],
        users: [RemoteUser],
        comments: [RemoteComment]) -> [Post] {
        return [Post]()
    }
    
    static private func map(postsData: Data) -> [RemotePost]? {
        let decoder = JSONDecoder()
        guard let posts = try? decoder.decode([RemotePost].self, from: postsData) else {
            return nil
        }

        return posts
    }
    
    static private func map(usersData: Data) -> [RemoteUser]? {
        let decoder = JSONDecoder()
        guard let posts = try? decoder.decode([RemoteUser].self, from: usersData) else {
            return nil
        }
        
        return posts
    }

    static private func map(commentsData: Data) -> [RemoteComment]? {
        let decoder = JSONDecoder()
        guard let posts = try? decoder.decode([RemoteComment].self, from: commentsData) else {
            return nil
        }
        
        return posts
    }
}

//
//  LocalDataLoaderAndSaver.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 02/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum RepositoryResult {
    case success([LocalUser])
    case error
}

protocol Repository {
    func allUsers(completion: @escaping (RepositoryResult) -> Void)
    func update(_ users: [LocalUser])
}

final class LocalDataLoaderAndSaver: DataLoader, DataSaver {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func update(_ users: [User]) {
        repository.update(LocalDataLoaderAndSaver.map(users))
    }
    
    func loadData(completion: @escaping (DataLoaderResult) -> Void) {
        repository.allUsers { result in
            switch result {
            case .success(let users): completion(.success(LocalDataLoaderAndSaver.map(users)))
            case .error: completion(.error(.local))
            }
        }
    }
}

private extension LocalDataLoaderAndSaver {
    static func map(_ users: [LocalUser]) -> [User] {
        return users.map {
            return User(id: $0.id,
                        name: $0.name,
                        username: $0.username,
                        posts: LocalDataLoaderAndSaver.map($0.posts))
        }
    }
    
    static func map(_ posts: [LocalPost]) -> [Post] {
        return posts.map {
            return Post(id: $0.id,
                        title: $0.title,
                        body: $0.body,
                        comments: LocalDataLoaderAndSaver.map($0.comments))
        }
    }
    
    static func map(_ comments: [LocalComment]) -> [Comment] {
        return comments.map {
            return Comment(id: $0.id,
                           name: $0.name,
                           body: $0.body)
        }
    }
}

private extension LocalDataLoaderAndSaver {
    static func map(_ users: [User]) -> [LocalUser] {
        return users.map {
            return LocalUser(id: $0.id,
                        name: $0.name,
                        username: $0.username,
                        posts: LocalDataLoaderAndSaver.map($0.posts))
        }
    }
    
    static func map(_ posts: [Post]) -> [LocalPost] {
        return posts.map {
            return LocalPost(id: $0.id,
                        title: $0.title,
                        body: $0.body,
                        comments: LocalDataLoaderAndSaver.map($0.comments))
        }
    }
    
    static func map(_ comments: [Comment]) -> [LocalComment] {
        return comments.map {
            return LocalComment(id: $0.id,
                           name: $0.name,
                           body: $0.body)
        }
    }
}

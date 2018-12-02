//
//  LocalDataLoader.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 02/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum RepositoryResult {
    case success([LocalUser])
    case error(Error)
}

protocol Repository {
    func allUsers(completion: @escaping (RepositoryResult) -> Void)
}

final class LocalDataLoader: DataLoader {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func loadData(completion: @escaping (DataLoaderResult) -> Void) {
        repository.allUsers { result in
            switch result {
            case .success(let users): completion(.success(LocalDataLoader.map(users)))
            case .error(_): completion(.error(.local))
            }
        }
    }
}

private extension LocalDataLoader {
    static func map(_ users: [LocalUser]) -> [User] {
        return users.map {
            return User(id: $0.id,
                        name: $0.name,
                        username: $0.username,
                        posts: LocalDataLoader.map($0.posts))
        }
    }
    
    static func map(_ posts: [LocalPost]) -> [Post] {
        return posts.map {
            return Post(id: $0.id,
                        title: $0.title,
                        body: $0.body,
                        comments: LocalDataLoader.map($0.comments))
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

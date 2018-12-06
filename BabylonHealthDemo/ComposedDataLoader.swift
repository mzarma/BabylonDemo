//
//  ComposedDataLoader.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 02/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

protocol DataSaver {
    func update(_ users: [User])
}

final class ComposedDataLoader: DataLoader {
    private let remote: RemoteDataLoader
    private let local: LocalDataLoader
    private let saver: DataSaver
    
    init(remote: RemoteDataLoader, local: LocalDataLoader, saver: DataSaver) {
        self.remote = remote
        self.local = local
        self.saver = saver
    }
    
    func loadData(completion: @escaping (DataLoaderResult) -> Void) {
        remote.loadData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.saver.update(users)
                completion(.success(users))
            case .error(_):
                self.local.loadData { result in
                    switch result {
                    case .success(let users): completion(.success(users))
                    case .error(_): completion(.error(.composed))
                    }
                }
            }
        }
    }
}

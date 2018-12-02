//
//  ComposedDataLoader.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 02/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class ComposedDataLoader: DataLoader {
    private let remoteDataLoader: RemoteDataLoader
    private let localDataLoader: LocalDataLoader
    
    init(remoteDataLoader: RemoteDataLoader, localDataLoader: LocalDataLoader) {
        self.remoteDataLoader = remoteDataLoader
        self.localDataLoader = localDataLoader
    }
    
    func loadData(completion: @escaping (DataLoaderResult) -> Void) {
        remoteDataLoader.loadData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users): completion(.success(users))
            case .error(_):
                self.localDataLoader.loadData { result in
                    switch result {
                    case .success(let users): completion(.success(users))
                    case .error(_): completion(.error(.composed))
                    }
                }
            }
        }
    }
}

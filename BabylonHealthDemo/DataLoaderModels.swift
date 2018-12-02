//
//  DataLoaderModels.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum DataLoaderError {
    case remote
    case local
}

enum DataLoaderResult {
    case success([User])
    case error(DataLoaderError)
}

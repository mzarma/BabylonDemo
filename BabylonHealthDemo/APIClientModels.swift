//
//  APIClientModels.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum APIClientResult {
    case success(Data)
    case error(APIClientError)
}

enum APIClientError {
    case badRequest
    case server
    case unknown
}

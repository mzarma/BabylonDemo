//
//  APIClient.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 29/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

class APIClient {
    
    private let session: URLSession
    
    init(_ session: URLSession) {
        self.session = session
    }
    
    func execute(_ request: URLRequest, completion: @escaping (APIClientResult) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if let data = data, response.statusCode > 199, response.statusCode < 300 {
                    completion(.success(data))
                } else if response.statusCode > 399 && response.statusCode < 500 {
                    completion(.error(.badRequest))
                } else if response.statusCode > 499 && response.statusCode < 600 {
                    completion(.error(.server))
                } else {
                    completion(.error(.unknown))
                }
            } else {
                completion(.error(.unknown))
            }
        }
        .resume()
    }
}

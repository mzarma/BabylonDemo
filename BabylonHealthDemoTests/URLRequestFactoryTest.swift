//
//  URLRequestFactoryTest.swift
//  BabylonHealthDemoTests
//
//  Created by Michail Zarmakoupis on 03/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import BabylonHealthDemo

class URLRequestFactoryTest: XCTestCase {
    func test_getPostsRequest() {
        let request = URLRequestFactory.getPosts()
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.host, "jsonplaceholder.typicode.com")
        XCTAssertEqual(request.url?.path, "/posts")
    }
    
    func test_getUsersRequest() {
        let request = URLRequestFactory.getUsers()
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.host, "jsonplaceholder.typicode.com")
        XCTAssertEqual(request.url?.path, "/users")
    }

    func test_getCommentsRequest() {
        let request = URLRequestFactory.getComments()
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.host, "jsonplaceholder.typicode.com")
        XCTAssertEqual(request.url?.path, "/comments")
    }
}

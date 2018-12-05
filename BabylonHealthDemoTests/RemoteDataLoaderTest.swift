//
//  RemoteDataLoaderTest.swift
//  BabylonHealthDemoTests
//
//  Created by Michail Zarmakoupis on 04/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import BabylonHealthDemo

class RemoteDataLoaderTest: XCTestCase {
    private weak var weakSUT: RemoteDataLoader?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_completesWithError_whenClientCompletesWithErrorForPostsRequest() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubResults = [.error(.unknown),
                              .success(validUsersData),
                              .success(validCommentsData)]
        sut.loadData { expectedResult = $0 }
        
        XCTAssertEqual(client.requests, expectedRequests)
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithError_whenClientCompletesSuccesfullyWithInvalidPostsData() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubResults = [.success(Data()),
                              .success(validUsersData),
                              .success(validCommentsData)]
        sut.loadData { expectedResult = $0 }

        XCTAssertEqual(client.requests, expectedRequests)
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithError_whenClientCompletesWithErrorForUsersRequest() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubResults = [.success(validUsersData),
                              .error(.unknown),
                              .success(validCommentsData)]
        sut.loadData { expectedResult = $0 }

        XCTAssertEqual(client.requests, expectedRequests)
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithError_whenClientCompletesSuccesfullyWithInvalidUsersData() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubResults = [.success(validPostsData),
                              .success(Data()),
                              .success(validCommentsData)]
        sut.loadData { expectedResult = $0 }

        XCTAssertEqual(client.requests, expectedRequests)
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }

    func test_completesWithError_whenClientCompletesWithErrorForCommentsRequest() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubResults = [.success(validPostsData),
                              .success(validUsersData),
                              .error(.unknown)]
        sut.loadData { expectedResult = $0 }

        XCTAssertEqual(client.requests, expectedRequests)
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithError_whenClientCompletesSuccesfullyWithInvalidCommentsData() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubResults = [.success(validPostsData),
                              .success(validUsersData),
                              .success(Data())]
        sut.loadData { expectedResult = $0 }

        XCTAssertEqual(client.requests, expectedRequests)
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithSuccess_whenClientCompletesSuccesfullyForAllRequests() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubResults = [.success(validPostsData),
                              .success(validUsersData),
                              .success(validCommentsData)]
        sut.loadData { expectedResult = $0 }

        XCTAssertEqual(client.requests, expectedRequests)
        switch expectedResult! {
        case .success(let users):
            XCTAssertEqual(users, expectedUsers)
        case .error(_): XCTFail("Should succeed")
        }
    }

    // MARK: - Helpers
    
    private let client = APIClientStub()
    
    private func makeSUT() -> RemoteDataLoader {
        let sut = RemoteDataLoader(client: client)
        weakSUT = sut
        return sut
    }
    
    private class APIClientStub: APIClient {
        convenience init() {
            self.init(URLSession.shared)
        }
        
        var stubResults: [APIClientResult] = []
        var requests = [URLRequest]()
        
        override func execute(_ request: URLRequest, completion: @escaping (APIClientResult) -> Void) {
            requests.append(request)
            switch request {
            case URLRequestFactory.getPosts():
                completion(stubResults[0])
            case URLRequestFactory.getUsers():
                completion(stubResults[1])
            case URLRequestFactory.getComments():
                completion(stubResults[2])
            default:
                completion(.error(.unknown))
            }
        }
    }
    
    private let validPostsData = "[{\"userId\": 1,\"id\": 1,\"title\": \"post title 1\",\"body\": \"post body 1\"},{\"userId\": 1,\"id\": 2,\"title\": \"post title 2\",\"body\": \"post body 2\"}]".data(using: .utf8)!
    private let validUsersData = "[{\"id\": 1,\"name\": \"user name 1\",\"username\": \"user username 1\",\"email\": \"\",\"address\": {\"street\": \"\",\"suite\": \"\",\"city\": \"\",\"zipcode\": \"\",\"geo\": {\"lat\": \"\",\"lng\": \"\"}},\"phone\": \"\",\"website\": \"\",\"company\": {\"name\": \"\",\"catchPhrase\": \"\",\"bs\": \"\"}},{\"id\": 2,\"name\": \"user name 2\",\"username\": \"user username 2\",\"email\": \"\",\"address\": {\"street\": \"\",\"suite\": \"\",\"city\": \"\",\"zipcode\": \"\",\"geo\": {\"lat\": \"\",\"lng\": \"\"}},\"phone\": \"\",\"website\": \"\",\"company\": {\"name\": \"\",\"catchPhrase\": \"\",\"bs\": \"\"}}]".data(using: .utf8)!
    private let validCommentsData = "[{\"postId\": 1,\"id\": 1,\"name\": \"comment name 1\",\"email\": \"\",\"body\": \"comment body 1\"},{\"postId\": 1,\"id\": 2,\"name\": \"comment name 2\",\"email\": \"\",\"body\": \"comment body 2\"}]".data(using: .utf8)!
    
    private let expectedRequests = [URLRequestFactory.getPosts(),
                                    URLRequestFactory.getUsers(),
                                    URLRequestFactory.getComments()]
    
    private let expectedUsers = [
        User(id: 1, name: "user name 1", username: "user username 1",
             posts: [
                Post(id: 1, title: "post title 1", body: "post body 1", comments: [
                    Comment(id: 1, name: "comment name 1", body: "comment body 1"),
                    Comment(id: 2, name: "comment name 2", body: "comment body 2")]),
                Post(id: 2, title: "post title 2", body: "post body 2", comments: [])]),
        User(id: 2, name: "user name 2", username: "user username 2", posts: [])]
}

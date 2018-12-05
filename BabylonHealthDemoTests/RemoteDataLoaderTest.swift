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
        
        client.stubs = [.error(.unknown),
                        .success(validUsersData),
                        .success(validCommentsData)]
        sut.loadData { result in
            expectedResult = result
        }
        waitForGroup()
        
        XCTAssertEqual(client.requests, [URLRequestFactory.getPosts(), URLRequestFactory.getUsers(), URLRequestFactory.getComments()])
        
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithError_whenClientCompletesSuccesfullyWithInvalidPostsData() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubs = [.success(Data()),
                        .success(validUsersData),
                        .success(validCommentsData)]
        sut.loadData { result in
            expectedResult = result
        }
        waitForGroup()
        
        XCTAssertEqual(client.requests, [URLRequestFactory.getPosts(), URLRequestFactory.getUsers(), URLRequestFactory.getComments()])
        
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithError_whenClientCompletesWithErrorForUsersRequest() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubs = [.success(validUsersData),
                        .error(.unknown),
                        .success(validCommentsData)]
        sut.loadData { result in
            expectedResult = result
        }
        waitForGroup()
        
        XCTAssertEqual(client.requests, [URLRequestFactory.getPosts(), URLRequestFactory.getUsers(), URLRequestFactory.getComments()])
        
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithError_whenClientCompletesSuccesfullyWithInvalidUsersData() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubs = [.success(validPostsData),
                        .success(Data()),
                        .success(validCommentsData)]
        sut.loadData { result in
            expectedResult = result
        }
        waitForGroup()
        
        XCTAssertEqual(client.requests, [URLRequestFactory.getPosts(), URLRequestFactory.getUsers(), URLRequestFactory.getComments()])
        
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }

    func test_completesWithError_whenClientCompletesWithErrorForCommentsRequest() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubs = [.success(validPostsData),
                        .success(validUsersData),
                        .error(.unknown)]
        sut.loadData { result in
            expectedResult = result
        }
        waitForGroup()
        
        XCTAssertEqual(client.requests, [URLRequestFactory.getPosts(), URLRequestFactory.getUsers(), URLRequestFactory.getComments()])
        
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithError_whenClientCompletesSuccesfullyWithInvalidCommentsData() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubs = [.success(validPostsData),
                        .success(validUsersData),
                        .success(Data())]
        sut.loadData { result in
            expectedResult = result
        }
        waitForGroup()
        
        XCTAssertEqual(client.requests, [URLRequestFactory.getPosts(), URLRequestFactory.getUsers(), URLRequestFactory.getComments()])
        
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithSuccess_whenClientCompletesSuccesfullyForAllRequests() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        XCTAssertEqual(client.requests, [])
        
        client.stubs = [.success(validPostsData),
                        .success(validUsersData),
                        .success(validCommentsData)]
        sut.loadData { result in
            expectedResult = result
        }
        waitForGroup()
        
        XCTAssertEqual(client.requests, [URLRequestFactory.getPosts(), URLRequestFactory.getUsers(), URLRequestFactory.getComments()])
        
        switch expectedResult! {
        case .success(let users):
            XCTAssertEqual(users, expectedUsers)
        case .error(_): XCTFail("Should succeed")
        }
    }


    // MARK: - Helpers
    
    private let client = APIClientStub()
    private let dispatchGroup = DispatchGroup()
    
    private func makeSUT() -> RemoteDataLoader {
        let sut = RemoteDataLoader(client: client)
        weakSUT = sut
        return sut
    }
    
    private func waitForGroup() {
        var didComplete = false;
        dispatchGroup.notify(queue: DispatchQueue.main) {
            didComplete = true
        }
        
        while !didComplete {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }

    private class APIClientStub: APIClient {
        var stubs: [APIClientResult] = []

        convenience init() {
            self.init(URLSession.shared)
        }
        
        var requests = [URLRequest]()
        
        override func execute(_ request: URLRequest, completion: @escaping (APIClientResult) -> Void) {
            requests.append(request)
            switch request {
            case URLRequestFactory.getPosts():
                completion(stubs[0])
            case URLRequestFactory.getUsers():
                completion(stubs[1])
            case URLRequestFactory.getComments():
                completion(stubs[2])
            default:
                completion(.error(.unknown))
            }
        }
    }
    
    private let validPostsData = "[\n  {\n    \"userId\": 1,\n    \"id\": 1,\n    \"title\": \"post title 1\",\n    \"body\": \"post body 1\"\n  },\n  {\n    \"userId\": 1,\n    \"id\": 2,\n    \"title\": \"post title 2\",\n    \"body\": \"post body 2\"\n  }  \n]".data(using: .utf8)!
    private let validUsersData = "[\n  {\n    \"id\": 1,\n    \"name\": \"user name 1\",\n    \"username\": \"user username 1\",\n    \"email\": \"Sincere@april.biz\",\n    \"address\": {\n      \"street\": \"Kulas Light\",\n      \"suite\": \"Apt. 556\",\n      \"city\": \"Gwenborough\",\n      \"zipcode\": \"92998-3874\",\n      \"geo\": {\n        \"lat\": \"-37.3159\",\n        \"lng\": \"81.1496\"\n      }\n    },\n    \"phone\": \"1-770-736-8031 x56442\",\n    \"website\": \"hildegard.org\",\n    \"company\": {\n      \"name\": \"Romaguera-Crona\",\n      \"catchPhrase\": \"Multi-layered client-server neural-net\",\n      \"bs\": \"harness real-time e-markets\"\n    }\n  },\n  {\n    \"id\": 2,\n    \"name\": \"user name 2\",\n    \"username\": \"user username 2\",\n    \"email\": \"Shanna@melissa.tv\",\n    \"address\": {\n      \"street\": \"Victor Plains\",\n      \"suite\": \"Suite 879\",\n      \"city\": \"Wisokyburgh\",\n      \"zipcode\": \"90566-7771\",\n      \"geo\": {\n        \"lat\": \"-43.9509\",\n        \"lng\": \"-34.4618\"\n      }\n    },\n    \"phone\": \"010-692-6593 x09125\",\n    \"website\": \"anastasia.net\",\n    \"company\": {\n      \"name\": \"Deckow-Crist\",\n      \"catchPhrase\": \"Proactive didactic contingency\",\n      \"bs\": \"synergize scalable supply-chains\"\n    }\n  }   \n]".data(using: .utf8)!
    private let validCommentsData = "[\n  {\n    \"postId\": 1,\n    \"id\": 1,\n    \"name\": \"comment name 1\",\n    \"email\": \"Eliseo@gardner.biz\",\n    \"body\": \"comment body 1\"\n  },\n  {\n    \"postId\": 1,\n    \"id\": 2,\n    \"name\": \"comment name 2\",\n    \"email\": \"Jayne_Kuhic@sydney.com\",\n    \"body\": \"comment body 2\"\n  }  \n]".data(using: .utf8)!
    
    private let expectedUsers = [User(id: 1, name: "user name 1", username: "user username 1", posts: [Post(id: 1, title: "post title 1", body: "post body 1", comments: [Comment(id: 1, name: "comment name 1", body: "comment body 1"), Comment(id: 2, name: "comment name 2", body: "comment body 2")]), Post(id: 2, title: "post title 2", body: "post body 2", comments: [])]), User(id: 2, name: "user name 2", username: "user username 2", posts: [])]
}

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
            XCTAssertEqual(users, testUsers)
        case .error(_): XCTFail("Should succeed")
        }
    }

    // MARK: - Helpers
    
    private let client = APIClientStub()
    
    private let expectedRequests = [URLRequestFactory.getPosts(),
                                    URLRequestFactory.getUsers(),
                                    URLRequestFactory.getComments()]
    
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
}

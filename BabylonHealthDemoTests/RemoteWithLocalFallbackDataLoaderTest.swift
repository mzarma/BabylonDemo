//
//  RemoteWithLocalFallbackDataLoaderTest.swift
//  BabylonHealthDemoTests
//
//  Created by Michail Zarmakoupis on 06/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import BabylonHealthDemo

class RemoteWithLocalFallbackDataLoaderTest: XCTestCase {
    private weak var weakSUT: RemoteWithLocalFallbackDataLoader?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_loadDataCompletesWithError_whenRemoteAndLocalCompleteWithError() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()

        sut.loadData { expectedResult = $0 }
        client.stubResults = []
        repository.complete!(.error)

        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .composed)
        }
    }
    
    func test_loadDataCompletesWithMappedUsers_whenRemoteCompleteWithErrorAndLocalCompletesWithSuccess() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        
        sut.loadData { expectedResult = $0 }
        client.stubResults = []
        repository.complete!(.success(testLocalUsers))
        
        switch expectedResult! {
        case .success(let mappedUsers):
            XCTAssertEqual(mappedUsers, testUsers)
        case .error(_): XCTFail("Should succeed")
        }
    }

    func test_loadDataCompletesWithMappedUsers_whenRemoteCompletesWithSuccess() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        
        client.stubResults = [.success(validPostsData),
                              .success(validUsersData),
                              .success(validCommentsData)]
        sut.loadData { expectedResult = $0 }

        switch expectedResult! {
        case .success(let mappedUsers):
            XCTAssertEqual(mappedUsers, testUsers)
        case .error(_): XCTFail("Should succeed")
        }
    }

    func test_loadDataTriggersUpdateUsers_whenRemoteCompletesWithSuccess() {
        let sut = makeSUT()
        XCTAssertEqual(saver.updateCallCount, 0)
        
        client.stubResults = [.success(validPostsData),
                              .success(validUsersData),
                              .success(validCommentsData)]
        sut.loadData { _ in }
        
        XCTAssertEqual(saver.updateCallCount, 1)
        XCTAssertEqual(saver.mappedUsers, testUsers)
    }

    // MARK: - Helpers
    
    private let client = APIClientStub()
    private let repository = RepositoryStub()
    private let saver = DataSaverSpy()
    
    private func makeSUT() -> RemoteWithLocalFallbackDataLoader {
        let remote = RemoteDataLoader(client: client)
        let local = LocalDataLoaderAndSaver(repository: repository)
        let sut = RemoteWithLocalFallbackDataLoader(remote: remote, local: local, saver: saver)
        weakSUT = sut
        return sut
    }
    
    private class APIClientStub: APIClient {
        convenience init() {
            self.init(URLSession.shared)
        }
        
        var stubResults: [APIClientResult] = []
        
        override func execute(_ request: URLRequest, completion: @escaping (APIClientResult) -> Void) {
            guard !stubResults.isEmpty else { return completion(.error(.unknown))}
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

    
    private class RepositoryStub: Repository {
        var complete: ((RepositoryResult) -> Void)?
        
        func allUsers(completion: @escaping (RepositoryResult) -> Void) {
            complete = completion
        }
        
        func update(_ users: [LocalUser]) {

        }
    }
    
    private class DataSaverSpy: DataSaver {
        var updateCallCount = 0
        var mappedUsers: [User]?
        
        func update(_ users: [User]) {
            updateCallCount += 1
            mappedUsers = users
        }
    }
}

//
//  ComposableDataLoaderTest.swift
//  BabylonHealthDemoTests
//
//  Created by Michail Zarmakoupis on 06/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import BabylonHealthDemo

class ComposableDataLoaderTest: XCTestCase {
    private weak var weakSUT: ComposedDataLoader?
    
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
        repository.complete!(.success(localUsers))
        
        switch expectedResult! {
        case .success(let mappedUsers):
            XCTAssertEqual(mappedUsers, users)
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
            XCTAssertEqual(mappedUsers, users)
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
        XCTAssertEqual(saver.mappedUsers, users)
    }

    // MARK: - Helpers
    
    private let client = APIClientStub()
    private let repository = RepositoryStub()
    private let saver = DataSaverSpy()
    
    private func makeSUT() -> ComposedDataLoader {
        let remote = RemoteDataLoader(client: client)
        let local = LocalDataLoader(repository: repository)
        let sut = ComposedDataLoader(remote: remote, local: local, saver: saver)
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

    private let localUsers = [
        LocalUser(id: 1, name: "user name 1",
                  username: "user username 1",posts: [
                    LocalPost(id: 1, title: "post title 1",
                              body: "post body 1", comments: [
                                LocalComment(id: 1, name: "comment name 1",
                                             body: "comment body 1"),
                                LocalComment(id: 2, name: "comment name 2",
                                             body: "comment body 2")]),
                    LocalPost(id: 2, title: "post title 2",
                              body: "post body 2", comments: [])]),
        LocalUser(id: 2, name: "user name 2",
                  username: "user username 2", posts: [])
    ]
    
    private let users = [
        User(id: 1, name: "user name 1",
             username: "user username 1",posts: [
                Post(id: 1, title: "post title 1",
                     body: "post body 1", comments: [
                        Comment(id: 1, name: "comment name 1",
                                body: "comment body 1"),
                        Comment(id: 2, name: "comment name 2",
                                body: "comment body 2")]),
                Post(id: 2, title: "post title 2",
                     body: "post body 2", comments: [])]),
        User(id: 2, name: "user name 2",
             username: "user username 2", posts: [])
    ]
    
    private let validPostsData = "[{\"userId\": 1,\"id\": 1,\"title\": \"post title 1\",\"body\": \"post body 1\"},{\"userId\": 1,\"id\": 2,\"title\": \"post title 2\",\"body\": \"post body 2\"}]".data(using: .utf8)!
    private let validUsersData = "[{\"id\": 1,\"name\": \"user name 1\",\"username\": \"user username 1\",\"email\": \"\",\"address\": {\"street\": \"\",\"suite\": \"\",\"city\": \"\",\"zipcode\": \"\",\"geo\": {\"lat\": \"\",\"lng\": \"\"}},\"phone\": \"\",\"website\": \"\",\"company\": {\"name\": \"\",\"catchPhrase\": \"\",\"bs\": \"\"}},{\"id\": 2,\"name\": \"user name 2\",\"username\": \"user username 2\",\"email\": \"\",\"address\": {\"street\": \"\",\"suite\": \"\",\"city\": \"\",\"zipcode\": \"\",\"geo\": {\"lat\": \"\",\"lng\": \"\"}},\"phone\": \"\",\"website\": \"\",\"company\": {\"name\": \"\",\"catchPhrase\": \"\",\"bs\": \"\"}}]".data(using: .utf8)!
    private let validCommentsData = "[{\"postId\": 1,\"id\": 1,\"name\": \"comment name 1\",\"email\": \"\",\"body\": \"comment body 1\"},{\"postId\": 1,\"id\": 2,\"name\": \"comment name 2\",\"email\": \"\",\"body\": \"comment body 2\"}]".data(using: .utf8)!
}

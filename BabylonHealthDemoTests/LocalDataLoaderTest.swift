//
//  LocalDataLoaderTest.swift
//  BabylonHealthDemoTests
//
//  Created by Michail Zarmakoupis on 05/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import BabylonHealthDemo

class LocalDataLoaderTest: XCTestCase {
    private weak var weakSUT: LocalDataLoader?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_loadDataCompletesWithError_whenRepositoryCompletesWithError() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        
        XCTAssertEqual(repository.allUsersCallCount, 0)

        sut.loadData { expectedResult = $0 }
        repository.complete!(.error)

        XCTAssertEqual(repository.allUsersCallCount, 1)
        switch expectedResult! {
        case .success(_): XCTFail("Should fail")
        case .error(let error): XCTAssertEqual(error, .local)
        }
    }

    func test_loadDataCompletesWithMappedUsers_whenRepositoryCompletesWithSuccess() {
        var expectedResult: DataLoaderResult?
        let sut = makeSUT()
        
        XCTAssertEqual(repository.allUsersCallCount, 0)
        
        sut.loadData { expectedResult = $0 }
        repository.complete!(.success(localUsers))
        
        XCTAssertEqual(repository.allUsersCallCount, 1)
        switch expectedResult! {
        case .success(let mappedUsers):
            XCTAssertEqual(mappedUsers, users)
        case .error(_): XCTFail("Should succeed")
        }
    }

    func test_update_triggersRepositoryUpdateWithMappedUsers() {
        let sut = makeSUT()
        
        XCTAssertEqual(repository.updateCallCount, 0)
        
        sut.update(users)
        
        XCTAssertEqual(repository.updateCallCount, 1)
        XCTAssertEqual(repository.localUsers, localUsers)
    }
    
    // MARK: - Helpers
    
    private let repository = RepositoryStub()
    
    private func makeSUT() -> LocalDataLoader {
        let sut = LocalDataLoader(repository: repository)
        weakSUT = sut
        return sut
    }
    
    private class RepositoryStub: Repository {
        var complete: ((RepositoryResult) -> Void)?
        var allUsersCallCount = 0
        var localUsers: [LocalUser]?
        var updateCallCount = 0
        
        func allUsers(completion: @escaping (RepositoryResult) -> Void) {
            allUsersCallCount += 1
            complete = completion
        }
        
        func update(_ users: [LocalUser]) {
            updateCallCount += 1
            localUsers = users
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
}

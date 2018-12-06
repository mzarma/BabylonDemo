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
        repository.complete!(.success(testLocalUsers))
        
        XCTAssertEqual(repository.allUsersCallCount, 1)
        switch expectedResult! {
        case .success(let mappedUsers):
            XCTAssertEqual(mappedUsers, testUsers)
        case .error(_): XCTFail("Should succeed")
        }
    }

    func test_update_triggersRepositoryUpdateWithMappedUsers() {
        let sut = makeSUT()
        
        XCTAssertEqual(repository.updateCallCount, 0)
        
        sut.update(testUsers)
        
        XCTAssertEqual(repository.updateCallCount, 1)
        XCTAssertEqual(repository.localUsers, testLocalUsers)
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
}

//
//  CoreDataRepositoryTest.swift
//  BabylonHealthDemoTests
//
//  Created by Michail Zarmakoupis on 06/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
import CoreData
@testable import BabylonHealthDemo

class CoreDataRepositoryTest: XCTestCase {
    private weak var weakSUT: CoreDataRepository?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        clearData()
        super.tearDown()
    }
    
    func test_allUsersAndUpdate() {
        let sut = makeSUT()
        
        sut.allUsers { result in
            switch result {
            case .success(let localUsers):
                XCTAssert(localUsers.isEmpty)
            case .error: XCTFail("Should succeed")
            }
        }

        save(testLocalUsers, context: container.viewContext)
        
        sut.allUsers { result in
            switch result {
            case .success(let localUsers):
                XCTAssertEqual(self.sorted(localUsers), self.sorted(testLocalUsers))
            case .error: XCTFail("Should succeed")
            }
        }
        
        sut.update(testUpdatedLocalUsers)

        sut.allUsers { result in
            switch result {
            case .success(let localUsers):
                XCTAssertEqual(self.sorted(localUsers), self.sorted(testUpdatedLocalUsers))
            case .error: XCTFail("Should succeed")
            }
        }
        
        sut.update([])

        sut.allUsers { result in
            switch result {
            case .success(let localUsers):
                XCTAssert(localUsers.isEmpty)
            case .error: XCTFail("Should succeed")
            }
        }
    }
    
    // MARK: - Helpers
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BabylonHealthDemo", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            precondition( description.type == NSInMemoryStoreType )
            if let error = error {
                fatalError("Create an in-memory coordinator failed \(error)")
            }
        }
        return container
    }()

    private func makeSUT() -> CoreDataRepository {
        let sut = CoreDataRepository(container: container)
        weakSUT = sut
        return sut
    }
    
    private func clearData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataUser")
        let users = try! container.viewContext.fetch(fetchRequest)
        users.forEach { user in
            let user = user as! NSManagedObject
            container.viewContext.delete(user)
        }
        try! container.viewContext.save()
    }
    
    private func save(_ users: [LocalUser], context: NSManagedObjectContext) {
        users.forEach { user in
            let coreDataUser = CoreDataUser(context: context)
            coreDataUser.id = Int64(user.id)
            coreDataUser.name = user.name
            coreDataUser.username = user.username
            user.posts.forEach { post in
                let coreDataPost = CoreDataPost(context: context)
                coreDataPost.id = Int64(post.id)
                coreDataPost.title = post.title
                coreDataPost.body = post.body
                coreDataPost.user = coreDataUser
                post.comments.forEach { comment in
                    let coreDataComment = CoreDataComment(context: context)
                    coreDataComment.id = Int64(comment.id)
                    coreDataComment.name = comment.name
                    coreDataComment.body = comment.body
                    coreDataComment.post = coreDataPost
                }
            }
        }
        do {
            try context.save()
        } catch {
            print("Error saving data \(error)")
        }
    }
    
    private func sorted(_ users: [LocalUser]) -> [LocalUser] {
        var sortedUsers = [LocalUser]()
        users.forEach {
            let posts = sorted($0.posts)
            sortedUsers.append(LocalUser(id: $0.id, name: $0.name, username: $0.username, posts: posts))
        }
        return sortedUsers.sorted { $0.id < $1.id }
    }
    
    private func sorted(_ posts: [LocalPost]) -> [LocalPost] {
        var sortedPosts = [LocalPost]()
        posts.forEach {
            let comments = $0.comments.sorted { $0.id < $1.id }
            sortedPosts.append(LocalPost(id: $0.id, title: $0.title, body: $0.body, comments: comments))
        }
        return sortedPosts.sorted { $0.id < $1.id }
    }
}

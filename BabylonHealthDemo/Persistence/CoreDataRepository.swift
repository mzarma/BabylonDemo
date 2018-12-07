//
//  CoreDataRepository.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 02/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataRepository: Repository {
    private let container: NSPersistentContainer
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        return self.container.newBackgroundContext()
    }()
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func allUsers(completion: @escaping (RepositoryResult) -> Void) {
        let request: NSFetchRequest<CoreDataUser> = CoreDataUser.fetchRequest()
        
        do {
            let users = try backgroundContext.fetch(request)
            completion(.success(CoreDataRepository.localUsers(from: users)))
        } catch {
            print("Error fetching data from context \(error)")
            completion(.error)
        }
    }
    
    func update(_ users: [LocalUser]) {
        clearUsers(backgroundContext)
        save(users, context: backgroundContext)
    }
    
    private func clearUsers(_ context: NSManagedObjectContext) {
        let request: NSFetchRequest<CoreDataUser> = CoreDataUser.fetchRequest()
        
        do {
            let coreDataUsers = try context.fetch(request)
            coreDataUsers.forEach { context.delete($0) }
            
        } catch {
            print("Error fetching data from context \(error)")
        }
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
}

private extension CoreDataRepository {
    static func localUsers(from coreDataUsers: [CoreDataUser]) -> [LocalUser] {
        let users: [LocalUser] = coreDataUsers.map {
            return LocalUser(
                id: Int($0.id),
                name: $0.name!,
                username: $0.username!,
                posts: ($0.posts!.allObjects as! [CoreDataPost])
                    .map {
                        return LocalPost(id: Int($0.id),
                                    title: $0.title!,
                                    body: $0.body!,
                                    comments: ($0.comments!.allObjects as! [CoreDataComment])
                                        .map {
                                            return LocalComment(id: Int($0.id),
                                                           name: $0.name!,
                                                           body: $0.body!)
                            }
                        )
                    }
            )
        }
        
        return users
    }
}

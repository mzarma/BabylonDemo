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
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BabylonHealthDemo")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            
        })
        return container
    }()
    
    func allUsers(completion: @escaping (RepositoryResult) -> Void) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<CoreDataUser> = CoreDataUser.fetchRequest()
        
        do {
            let users = try context.fetch(request)
            completion(.success(CoreDataRepository.localUsers(from: users)))
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func update(_ users: [LocalUser]) {
        
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

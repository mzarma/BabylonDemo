//
//  CoreDataGateway.swift
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
        
    }
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
            }
        }
    }
}

//
//  AppDelegate.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 29/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navigationController = UINavigationController()
        let client = APIClient(URLSession.shared)
        let repository = CoreDataRepository()
        let remote = RemoteDataLoader(client: client)
        let local = LocalDataLoader(repository: repository)
        let loader = ComposedDataLoader(remote: remote, local: local)
        let postsViewFactory = PhonePostsViewFactory(loader: loader)
        coordinator = Coordinator(navigation: navigationController,
                    postsViewFactory: postsViewFactory,
                    postDetailViewFactory: postsViewFactory)
        
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

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
    var flow: Flow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navigationController = UINavigationController()
        let client = APIClient(session: URLSession.shared)
        let loader = RemotePostsLoader(client: client)
        let postsViewFactory = PhonePostsViewFactory(loader: loader)
        let postDetailViewFactory = PhonePostDetailViewFactory()
        flow = Flow(navigation: navigationController,
                    postsViewFactory: postsViewFactory,
                    postDetailViewFactory: postDetailViewFactory)
        
        flow?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

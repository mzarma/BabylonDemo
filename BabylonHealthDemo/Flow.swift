//
//  Flow.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class Flow {
    private let navigation: UINavigationController
    private let postsViewFactory: PostsViewFactory
    
    init(navigation: UINavigationController, postsViewFactory: PostsViewFactory) {
        self.navigation = navigation
        self.postsViewFactory = postsViewFactory
    }
    
    func start() {
        let postsView = postsViewFactory.makePostsView { _ in
            
        }
        
        navigation.setViewControllers([postsView], animated: false)
    }
}
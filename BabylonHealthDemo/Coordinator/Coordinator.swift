//
//  Coordinator.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol PostsViewFactory {
    func makePostsView(_ selected: @escaping (Post) -> Void) -> UIViewController
}

protocol PostDetailViewFactory {
    func makePostDetailView(post: Post) -> UIViewController
}

final class Coordinator {
    private let navigation: UINavigationController
    private let postsViewFactory: PostsViewFactory
    private let postDetailViewFactory: PostDetailViewFactory
    
    init(navigation: UINavigationController,
         postsViewFactory: PostsViewFactory,
         postDetailViewFactory: PostDetailViewFactory) {
        self.navigation = navigation
        self.postsViewFactory = postsViewFactory
        self.postDetailViewFactory = postDetailViewFactory
    }
    
    func start() {
        let postsView = postsViewFactory.makePostsView { [weak self] post in
            guard let self = self else { return }
            let postDetailView = self.postDetailViewFactory.makePostDetailView(post: post)
            self.navigation.pushViewController(postDetailView, animated: true)
        }
        
        setupNavigation()
        navigation.setViewControllers([postsView], animated: false)
    }
    
    private func setupNavigation() {
        navigation.navigationBar.barTintColor = UIColor.customPurple
        navigation.navigationBar.tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}

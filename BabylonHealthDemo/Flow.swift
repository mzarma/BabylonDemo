//
//  Flow.swift
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
    func makePostDetailView(post: Post, author: String) -> UIViewController
}

final class Flow {
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
            let postDetailView = self.postDetailViewFactory.makePostDetailView(post: post, author: "")
            self.navigation.pushViewController(postDetailView, animated: true)
        }
        
        navigation.setViewControllers([postsView], animated: false)
    }
}

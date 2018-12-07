//
//  PhonePostsViewFactory.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol DataLoader {
    func loadData(completion: @escaping (DataLoaderResult) -> Void)
}

final class PhonePostsViewFactory: PostsViewFactory, PostDetailViewFactory {
    private var users = [User]()
    
    private let loader: DataLoader
    
    init(loader: DataLoader) {
        self.loader = loader
    }
    
    func makePostsView(_ selected: @escaping (Post) -> Void) -> UIViewController {
        let dataSourceDelegate = PostsDataSourceDelegate(noPostsText: "No Posts") { postViewModel in
            selected(postViewModel.post)
        }
        
        let viewController = CustomTableViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)
        viewController.title = PostViewModel.barTitle
        
        loader.loadData { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                let allPosts = users.reduce([Post](), { result, user in
                    result + user.posts
                })
                dataSourceDelegate.posts = allPosts.compactMap { PostViewModel(post: $0) }
                DispatchQueue.main.async {
                    viewController.tableView.reloadData()
                }
            case .error(_): break
            }
        }
        
        return viewController
    }
    
    func makePostDetailView(post: Post) -> UIViewController {
        let postDetail = PostDetailViewModel(post: post, users: users)
        let dataSourceDelegate = PostDetailDataSourceDelegate(postDetail: postDetail)
        let viewController = CustomTableViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)
        viewController.title = postDetail.title
        return viewController
    }
}

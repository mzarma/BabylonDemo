//
//  PhonePostsViewFactory.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol PostsViewFactory {
    func makePostsView(_ selected: @escaping (Post) -> Void) -> UIViewController
}

final class PhonePostsViewFactory: PostsViewFactory {
    private let loader: PostsLoader
    
    init(loader: PostsLoader) {
        self.loader = loader
    }
    
    func makePostsView(_ selected: @escaping (Post) -> Void) -> UIViewController {
        let dataSourceDelegate = PostsDataSourceDelegate(noPostsText: "No Posts") { postViewModel in
            selected(postViewModel.post)
        }
        
        let postsViewController = CustomTableViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)
        
        loader.loadPosts { result in
            switch result {
            case .success(let posts):
                dataSourceDelegate.posts = posts.compactMap { PostViewModel(post: $0) }
                DispatchQueue.main.async {
                    postsViewController.tableView.reloadData()
                }
            case .error(_): break
            }
        }
        
        return postsViewController
    }
}

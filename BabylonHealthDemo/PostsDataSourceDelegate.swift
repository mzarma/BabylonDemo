//
//  PostsDataSourceDelegate.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 29/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

struct PostsViewModel {
    
}

final class PostsDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var posts = [PostsViewModel]()
    
    private let noPostsText: String
    private let postSelection: (PostsViewModel) -> Void
    
    init(noPostsText: String, postSelection: @escaping (PostsViewModel) -> Void) {
        self.noPostsText = noPostsText
        self.postSelection = postSelection
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count > 0 ? posts.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

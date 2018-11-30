//
//  PostsDataSourceDelegate.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 29/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

struct PostViewModel {
    let post: Post
    
    var title: String {
        return post.title
    }
}

final class PostsDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var posts = [PostViewModel]()
    
    private let noPostsText: String
    private let postSelection: (PostViewModel) -> Void
    
    init(noPostsText: String, postSelection: @escaping (PostViewModel) -> Void) {
        self.noPostsText = noPostsText
        self.postSelection = postSelection
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count > 0 ? posts.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return posts.count > 0 ? configuredPostsCell(at: indexPath) : configuredNoPostsCell()
    }
    
    private func configuredNoPostsCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = noPostsText
        return cell
    }
    
    private func configuredPostsCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}

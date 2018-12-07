//
//  PostsDataSourceDelegate.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 29/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

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
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if posts.count > 0 {
            postSelection(posts[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = tableView.bounds.width
        let height = TableViewResizableCell.height(constrainedTo: width, for: posts[indexPath.row].title)
        return height > 44 ? height : 44
    }
    
    private func configuredNoPostsCell() -> UITableViewCell {
        let cell = TableViewResizableCell()
        cell.labelText = noPostsText
        return cell
    }
    
    private func configuredPostsCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewResizableCell()
        cell.labelText = posts[indexPath.row].title
        return cell
    }
}

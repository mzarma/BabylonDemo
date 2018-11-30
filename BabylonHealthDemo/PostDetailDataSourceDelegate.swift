//
//  PostDetailDataSourceDelegate.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

struct User {
    
}

struct Comment {
    
}

struct PostDetail {
    let author: String
    let description: String
    let numberOfComments: Int
}

struct PostDetailViewModel {
    let postDetail: PostDetail
    
    var author: String {
        return postDetail.author
    }
    
    var description: String {
        return postDetail.description
    }
    
    var numberOfComments: String {
        return String(postDetail.numberOfComments)
    }
    
    static let authorTitle = "Author"
    static let descriptionTitle = "Description"
    static let numberOfCommentsTitle = "Comments"
}

final class PostDetailDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let postDetail: PostDetailViewModel
    
    init(postDetail: PostDetailViewModel) {
        self.postDetail = postDetail
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

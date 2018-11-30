//
//  PostDetailDataSourceDelegate.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

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

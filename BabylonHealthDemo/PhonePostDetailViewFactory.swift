//
//  PhonePostDetailViewFactory.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 30/11/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class PhonePostDetailViewFactory: PostDetailViewFactory {
    
    func makePostDetailView(post: Post, user: User) -> UIViewController {
        let postDetail = PostDetailViewModel(post: post, user: user)
        let dataSourceDelegate = PostDetailDataSourceDelegate(postDetail: postDetail)
        return CustomTableViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)
    }
}

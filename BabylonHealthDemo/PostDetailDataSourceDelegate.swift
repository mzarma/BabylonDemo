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
        return TableStructure.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case TableStructure.authorTitle.rawValue: return defaultCell(text: PostDetailViewModel.authorTitle)
        case TableStructure.author.rawValue: return defaultCell(text: postDetail.author)
        case TableStructure.descriptionTitle.rawValue: return defaultCell(text: PostDetailViewModel.descriptionTitle)
        case TableStructure.author.rawValue: return defaultCell(text: postDetail.description)
        case TableStructure.numberOfCommentsTitle.rawValue: return defaultCell(text: PostDetailViewModel.numberOfCommentsTitle)
        case TableStructure.numberOfComments.rawValue: return defaultCell(text: postDetail.numberOfComments)
        default: return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case TableStructure.description.rawValue: return 120
        default: return 44
        }
    }
    
    private func defaultCell(text: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = text
        return cell
    }
}

private enum TableStructure: Int {
    case authorTitle = 0
    case author
    case descriptionTitle
    case description
    case numberOfCommentsTitle
    case numberOfComments
    case count
}

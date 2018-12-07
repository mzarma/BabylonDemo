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
        case TableStructure.authorTitle.rawValue: return titleCell(text: PostDetailViewModel.authorTitle)
        case TableStructure.author.rawValue: return resizableCell(text: postDetail.author)
        case TableStructure.descriptionTitle.rawValue: return titleCell(text: PostDetailViewModel.descriptionTitle)
        case TableStructure.description.rawValue: return resizableCell(text: postDetail.description)
        case TableStructure.numberOfCommentsTitle.rawValue: return titleCell(text: PostDetailViewModel.numberOfCommentsTitle)
        case TableStructure.numberOfComments.rawValue: return resizableCell(text: postDetail.numberOfComments)
        default: return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = tableView.bounds.width

        switch indexPath.row {
        case TableStructure.description.rawValue: return TableViewResizableCell.height(constrainedTo: width, for: postDetail.description)
        default: return 44
        }
    }
    
    private func titleCell(text: String) -> UITableViewCell {
        let cell = TableViewTitleCell()
        cell.labelText = text
        cell.selectionStyle = .none
        return cell
    }

    private func resizableCell(text: String) -> UITableViewCell {
        let cell = TableViewResizableCell()
        cell.labelText = text
        cell.selectionStyle = .none
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

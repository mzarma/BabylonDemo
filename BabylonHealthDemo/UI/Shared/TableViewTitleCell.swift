//
//  TableViewTitleCell.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 07/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

class TableViewTitleCell: UITableViewCell {
    private static let font = UIFont(name: "Avenir-Black", size: 18)!
    private static let margin: CGFloat = 12
    
    private let label = UILabel()
    
    var labelText: String {
        set { label.text = newValue }
        get { return label.text ?? "" }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !label.isDescendant(of: contentView) else { return }
        
        configureLabel()
    }
    
    private func configureLabel() {
        contentView.addSubview(label)
        
        label.font = TableViewTitleCell.font
        
        label.translatesAutoresizingMaskIntoConstraints = false

        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TableViewTitleCell.margin).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TableViewTitleCell.margin).isActive = true
    }
}

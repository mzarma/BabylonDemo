//
//  ResizableTableViewCell.swift
//  BabylonHealthDemo
//
//  Created by Michail Zarmakoupis on 07/12/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

class ResizableTableViewCell: UITableViewCell {
    private static let font = UIFont(name: "Avenir", size: 18)!
    private static let margin: CGFloat = 8
    
    private let label = UILabel()
    
    var labelText: String {
        set { label.attributedText = ResizableTableViewCell.attributed(for: newValue) }
        get { return label.attributedText?.string ?? "" }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !label.isDescendant(of: contentView) else { return }
        
        configureLabel()
    }
    
    private func configureLabel() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ResizableTableViewCell.margin).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ResizableTableViewCell.margin).isActive = true
    }
    
    static func height(constrainedTo width: CGFloat, for text: String) -> CGFloat {
        let margins = ResizableTableViewCell.margin * 2
        let size = CGSize(width: width - margins, height: .greatestFiniteMagnitude)
        return attributed(for: text)
            .boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            .integral
            .height
    }
    
    private static func attributed(for string: String) -> NSAttributedString {
        return NSAttributedString(string: string,
                                  attributes: [NSAttributedString.Key.font: font])
    }
}


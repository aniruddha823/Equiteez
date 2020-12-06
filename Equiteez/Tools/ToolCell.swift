//
//  File.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/23/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit

class ToolCell: UICollectionViewCell {
    
    var rowNumber: Int?
    
    @IBOutlet weak var toolImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setupToolCell(img: UIImage, title: String, description: String) {
        print(contentView.frame.width)
        
        toolImageView.image = img
        toolImageView.layer.cornerRadius = 10
        toolImageView.layer.masksToBounds = true
        toolImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {

        layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        
        layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
}

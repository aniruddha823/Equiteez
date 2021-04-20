//
//  NewsCell.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 4/12/21.
//  Copyright © 2021 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit
import CollectionViewSlantedLayout

class NewsCell: CollectionViewSlantedCell {
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleSource: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    
    var imageHeight: CGFloat {
        return (articleImage?.image?.size.height) ?? 0.0
    }

    var imageWidth: CGFloat {
        return (articleImage?.image?.size.width) ?? 0.0
    }
    
    func offset(_ offset: CGPoint) {
        articleImage.frame = articleImage.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
    
    func setArticleImage(imageURL: String) {
        let imgURL = URL(string: imageURL)
        
        articleImage.layer.masksToBounds = true
        articleImage.sd_setImage(with: imgURL)
        
//        articleImage.image = #imageLiteral(resourceName: "image-bitcoin")
//        print("img width: \(articleImage.frame.width), img height: \(articleImage.frame.height)")
    }
    
    func setHeadline(text: String) {
        articleTitle.text = text
    }
    
    func setArticleSource(text: String) {
        articleSource.text = text
    }
    
    func setArticleDate(text: String) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "PST")
        formatter.dateFormat = "MMM dd, yyyy"
        
        let formatter2 = DateFormatter()
        formatter2.timeZone = TimeZone(identifier: "PST")
        formatter2.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        articleDate.text = formatter.string(from: formatter2.date(from: text) ?? Date())
    }
}

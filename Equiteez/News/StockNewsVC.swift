//
//  StockNewsVC.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 4/11/21.
//  Copyright © 2021 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit
import CollectionViewSlantedLayout
import SafariServices

class StockNewsVC: UIViewController {
    var ticker = ""
    var articles = [Article]()
    let yOffsetSpeed: CGFloat = 150.0
    let xOffsetSpeed: CGFloat = 100.0
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: CollectionViewSlantedLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        newsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        let dg = DispatchGroup()
        dg.enter()
        FMPquery.getNews(symbol: ticker) { (articles) in
            self.articles = articles
            dg.leave()
        }
        
        dg.notify(queue: .main) {
            self.collectionViewLayout.isFirstCellExcluded = true
            self.collectionViewLayout.isLastCellExcluded = true
            self.collectionViewLayout.slantingSize = 10
            self.collectionViewLayout.lineSpacing = 5
            
            self.newsCollectionView.delegate = self
            self.newsCollectionView.dataSource = self
            self.newsCollectionView.register(UINib(nibName: "NewsCell", bundle: nil), forCellWithReuseIdentifier: "snc")
            self.newsCollectionView.reloadData()
        }
    }
}

extension StockNewsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "snc", for: indexPath) as! NewsCell
        cell.setArticleImage(imageURL: articles[indexPath.row].imageURL)
        cell.setHeadline(text: articles[indexPath.row].title)
        cell.setArticleSource(text: articles[indexPath.row].siteName)
        cell.setArticleDate(text: articles[indexPath.row].datePublished)
        
        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
        }

        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: NSIndexPath) {
//
//
//    }
}

extension StockNewsVC: CollectionViewDelegateSlantedLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("idx row: \(indexPath.row), article url: \(articles[indexPath.row].articleURL)")
        
        if let url = URL(string: articles[indexPath.row].articleURL) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: CollectionViewSlantedLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}


extension StockNewsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let newsCollectionView = newsCollectionView else {return}
        guard let visibleCells = newsCollectionView.visibleCells as? [NewsCell] else {return}
        for parallaxCell in visibleCells {
            let yOffset = ((newsCollectionView.contentOffset.y - parallaxCell.frame.origin.y) / parallaxCell.imageHeight) / 3
            let xOffset = ((newsCollectionView.contentOffset.x - parallaxCell.frame.origin.x) / parallaxCell.imageWidth) / 3
            parallaxCell.offset(CGPoint(x: xOffset * xOffsetSpeed, y: yOffset * yOffsetSpeed))
        }
    }
}


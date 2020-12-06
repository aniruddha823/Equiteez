//
//  ToolsVC.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/7/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit

class ToolsVC: UIViewController {
    
    @IBOutlet weak var toolsCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toolsCollectionView.delegate = self
        toolsCollectionView.dataSource = self
        toolsCollectionView.collectionViewLayout = AlternatingLayout()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        toolsCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ToolsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = toolsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ToolCell
        cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        if indexPath.row == 0 {
            cell.setupToolCell(img: #imageLiteral(resourceName: "image-currency"), title: "Forex Conversion", description: "Use this tool to find the exchange rates of various physical currencies.")
        } else if indexPath.row == 1 {
            cell.setupToolCell(img: #imageLiteral(resourceName: "image-bitcoin"), title: "Crypto Checker", description: "Use this tool to find the current prices of various cryptocurrencies.")
        }
        
        return cell
    }
}

class AlternatingLayout: UICollectionViewFlowLayout {
    
    var contentSize: CGSize = .zero
    var cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    private let cellSize = CGSize(width: 250, height: 300)
    private let ySpacing: CGFloat = 20

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.maxY)
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView else { return }
        cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
        var currentYposition: CGFloat = 0
        
        for section in 0 ..< collectionView.numberOfSections {
            for itemIndex in 0 ..< collectionView.numberOfItems(inSection: section) {
                
                let indexPath = IndexPath(item: itemIndex, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let xCenter = itemIndex % 2 == 0 ? CGFloat(integerLiteral: 145) : CGFloat(integerLiteral: 230)
                let yCenter = currentYposition + (cellSize.height / 2)
                
                attributes.size = cellSize
                attributes.center = CGPoint(x: xCenter, y: yCenter)
                cellAttributes[indexPath] = attributes
                currentYposition += cellSize.height + ySpacing
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if cellAttributes[indexPath] != nil {
            return cellAttributes[indexPath]
        }

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttributes.values.filter { rect.intersects($0.frame) }
    }
}

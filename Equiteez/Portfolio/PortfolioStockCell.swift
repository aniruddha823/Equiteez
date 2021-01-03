//
//  PortfolioStockCell.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 12/27/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PortfolioStockCell: UITableViewCell {
    
    @IBOutlet weak var stockTickerLabel: UILabel!
    @IBOutlet weak var shareAmountLabel: UILabel!
    @IBOutlet weak var stockPositionLabel: UILabel!
    
    var mm: Double = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func fetchNib() -> UINib {
        let nib = UINib(nibName: "PortfolioStockCell", bundle: nil)
        
        return nib
    }
    
    func setup(ticker: String, sharesOwned: Int) {
        stockTickerLabel.text = ticker
        shareAmountLabel.text = "\(sharesOwned) shares"
        
        FMPquery.getCurrentPrice(symbol: ticker) { [weak self] (price) in
            self?.stockPositionLabel.text = "$\(String(format: "%.2f", price * Double(sharesOwned)))"
        }
    }
}

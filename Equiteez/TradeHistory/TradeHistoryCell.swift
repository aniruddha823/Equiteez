//
//  TradeHistoryCell.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 12/28/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SDWebImage

class TradeHistoryCell: UITableViewCell {
    
    
    @IBOutlet weak var tickerTypeLabel: UILabel!
    @IBOutlet weak var shareAmountLabel: UILabel!
    @IBOutlet weak var transactionPriceLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func fetchNib() -> UINib {
        let nib = UINib(nibName: "PortfolioStockCell", bundle: nil)
        
        return nib
    }
    
    func setup(ticker: String, transactionType: String, transactionShares: Int, transactionPrice: Double, transactionDate: Double) {
        tickerTypeLabel.text = "\(ticker) - \(transactionType)"
        shareAmountLabel.text = "\(transactionShares) shares"
        transactionPriceLabel.text = "$\(String(format: "%.2f", transactionPrice))"
        
        if transactionType == "Buy" {
            shareAmountLabel.textColor = #colorLiteral(red: 0, green: 0.8085238338, blue: 0.4679548144, alpha: 1)
            transactionPriceLabel.textColor = #colorLiteral(red: 0.83269912, green: 0.2819902301, blue: 0.2545348406, alpha: 1)
        } else if transactionType == "Sell" {
            shareAmountLabel.textColor = #colorLiteral(red: 0.83269912, green: 0.2819902301, blue: 0.2545348406, alpha: 1)
            transactionPriceLabel.textColor = #colorLiteral(red: 0, green: 0.8085238338, blue: 0.4679548144, alpha: 1)
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "PST")
        formatter.dateFormat = "MMM dd, yyyy h:mm a"
        let formattedDate = formatter.string(from: Date(timeIntervalSince1970: transactionDate))
        
        transactionDateLabel.text = formattedDate
    }
}

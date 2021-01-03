//
//  DetailsCell.swift
//  Sample
//
//  Created by Aniruddha Prabhu on 6/21/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import FaveButton

class DetailsView: UIView {
    var symbol = ""
    var savedCount : Int?
    
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var percentChange: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    func setupCell(ticker: String) {
        symbol = ticker
        percentChange.layer.cornerRadius = 10
        
        FMPquery.getCurrentPrice(symbol: ticker) { [weak self] (price) in
            self?.currentPrice.text = "$" + String(format: "%.2f", price)
        }
        
        FMPquery.getAlternateQuote(symbol: ticker) { [weak self] (open, close, high, low, pchg, date) in
            NumDateFormatter.formatPercent(percentage: Double(pchg) ?? 0, label: self!.percentChange)
            self?.dateTime.text = NumDateFormatter.convertDate(dateString: date)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: NSNotification.Name(rawValue: "updateLabels"), object: nil)
    }
    
    @objc func updateLabels(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            currentPrice.text = dict["price"] as? String ?? ""
            NumDateFormatter.formatPercent(percentage: Double(dict["percent"] as? String ?? "0") ?? 0, label: percentChange)
            dateTime.text = dict["date"] as? String ?? ""
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

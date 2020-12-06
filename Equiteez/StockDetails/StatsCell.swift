//
//  StatsCell.swift
//  Sample
//
//  Created by Aniruddha Prabhu on 6/21/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit

class StatsCell: UICollectionViewCell {

    var ticker = ""
    
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var peratioLabel: UILabel!
    @IBOutlet weak var marketcapLabel: UILabel!
    
    func setupCell(ticker: String) {
        FMPquery.getProfile(symbol: ticker) { (ticker, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl) in
        
            self.volumeLabel.text = NumDateFormatter.getFormattedNumberString(num: avgv)
            self.marketcapLabel.text = NumDateFormatter.getFormattedNumberString(num: mkcp)
        }
        
        FMPquery.getQuote(symbol: ticker) { (open, close, high, low, pchg, date) in
            self.openLabel.text = open
            self.highLabel.text = high
            self.lowLabel.text = low
        }
    }
}

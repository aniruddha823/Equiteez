//
//  StatsCell.swift
//  Sample
//
//  Created by Aniruddha Prabhu on 6/21/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit

class StatsView: UIView {

    var ticker = ""
    
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var peratioLabel: UILabel!
    @IBOutlet weak var marketcapLabel: UILabel!
    
    func setupCell(ticker: String) {
        FMPquery.getQuote(symbol: ticker) { [weak self] (open, high, low, volume, per, mcap) in
            
            self?.openLabel.text = String(format: "%.2f", open)
            self?.highLabel.text = String(format: "%.2f", high)
            self?.lowLabel.text = String(format: "%.2f", low)
            self?.volumeLabel.text = NumDateFormatter.getFormattedNumberString(num: volume)
            self?.peratioLabel.text = String(format: "%.2f", per)
            self?.marketcapLabel.text = NumDateFormatter.getFormattedNumberString(num: mcap)
        }
    }
}

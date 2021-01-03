//
//  StockCell.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/8/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

//class StockCellView: UIView {
//
//}

import UIKit
import SDWebImage

class StockCell: UITableViewCell {
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var currentVolume: UILabel!
    @IBOutlet weak var currentPercentChange: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func fetchNib() -> UINib {
        let nib = UINib(nibName: "StockCell", bundle: nil)
        
        return nib
    }
    
    func setupCellText(name: String, ticker: String) {
        companyName.text = name
        symbol.text = "(\(ticker))"
    }
    
    func setupCellNumbers(ticker: String) {
        FMPquery.getCurrentPrice(symbol: ticker) { (price) in
            self.currentPrice.text = "$" + String(format: "%.2f", price)
        }
        
        FMPquery.getProfile(symbol: ticker) { [weak self] (ticker, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl, cmpe) in
            
            NumDateFormatter.formatPercent(percentage: Double(pchg) ?? 0, label: self!.currentPercentChange)
            
            self?.currentVolume.text = "Vol: \(NumDateFormatter.getFormattedNumberString(num: avgv))"
        }
    }
    
    // Set the logo of the cell according to the url provided
    func setLogo(logoURL: String) {
        companyLogo.layer.masksToBounds = true
        let imgURL = URL(string: logoURL)
        companyLogo.sd_setImage(with: imgURL)
    }
}



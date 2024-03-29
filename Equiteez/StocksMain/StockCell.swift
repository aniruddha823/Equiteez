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
import Charts

class StockCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var currentVolume: UILabel!
    @IBOutlet weak var currentPercentChange: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var priceGraph: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func fetchNib() -> UINib {
        let nib = UINib(nibName: "SavedStockCell", bundle: nil)
        
        return nib
    }
    
    func setupCellText(name: String, ticker: String) {
        companyName.text = name
        symbol.text = "(\(ticker))"
    }
    
    func setupCellNumbers(price: Double, percentage: Double, volume: Double) {
        currentPercentChange.layer.masksToBounds = true
        currentPercentChange.layer.cornerRadius = currentPercentChange.frame.height / 2
        
        currentPrice.text = "$" + String(format: "%.2f", price)
        NumDateFormatter.formatPercent(percentage: percentage, label: currentPercentChange)
        currentVolume.text = "Vol: \(NumDateFormatter.getFormattedNumberString(num: volume))"
    }
    
    func setupCellNumbers2(ticker: String) {
            currentPercentChange.layer.masksToBounds = true
            currentPercentChange.layer.cornerRadius = currentPercentChange.frame.height / 2
            
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
    
    func setupAppearance() {
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 1
    }
}



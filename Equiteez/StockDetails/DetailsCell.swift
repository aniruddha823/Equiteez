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

class DetailsCell: UICollectionViewCell {
    var symbol = ""
    var savedCount : Int?
    
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var percentChange: UILabel!
    @IBOutlet weak var saveButton: FaveButton!
    @IBOutlet weak var dateTime: UILabel!
    
    @IBAction func saveToggle(_ sender: Any) {
        let state = saveButton.isSelected
        let last_order = try? PersistentService.context.fetch(Stock.getSortedFetchRequest()).last?.order ?? 0
        
        if(state) {
            do {
                FMPquery.getProfile(symbol: symbol) { (tick, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl) in
                    
                    let newStock = Stock(context: PersistentService.context)
                    newStock.symbol = tick
                    newStock.companyName = cmpn
                    newStock.companyDescription = cmpd
                    newStock.companyCEO = cmpc
                    newStock.companyIndustry = cmpi
                    newStock.companyWebsite = cmpw
                    newStock.companyLogoURL = cmpl
                    
                    if let last_order = last_order {
                        newStock.order = last_order + 1
                    }
                    
                    PersistentService.saveContext()
                }
            }
            catch { print("failed saving") }
        } else if !state {
            let fetchRequest: NSFetchRequest<Stock> = Stock.getSortedFetchRequest()
            fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
            do {
                let result = try PersistentService.context.fetch(fetchRequest)
                for object in result {
                    PersistentService.context.delete(object)
                }
                
                PersistentService.saveContext()
            } catch { print(error) }
        }
    }
    
    func setupCell(ticker: String) {
        symbol = ticker
        
        FMPquery.getCurrentPrice(symbol: ticker) { (price) in
            self.currentPrice.text = "$" + String(format: "%.2f", price)
        }
        
        FMPquery.getQuote(symbol: ticker) { (open, close, high, low, pchg, date) in
            NumDateFormatter.formatPercent(percentage: Double(pchg) ?? 0, label: self.percentChange)
            self.dateTime.text = NumDateFormatter.convertDate(dateString: date)
        }
        
        let fetchRequest: NSFetchRequest<Stock> = Stock.getSortedFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", ticker)
        
        do {
            let result = try PersistentService.context.fetch(fetchRequest)

            if(result.count > 0) {
                saveButton.setSelected(selected: true, animated: false)
            } else {}
        } catch { print(error) }
        
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

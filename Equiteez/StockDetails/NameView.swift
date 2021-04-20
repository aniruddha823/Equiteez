//
//  NameView.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/2/21.
//  Copyright © 2021 Aniruddha Prabhu. All rights reserved.
//

import CoreData
import FaveButton
import UIKit

class NameView: UIView {
    var symbol = ""
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var saveButton: FaveButton!
    
    @IBAction func saveToggle(_ sender: Any) {
        let state = saveButton.isSelected
        let last_order = try? PersistentService.context.fetch(Stock.getSortedFetchRequest()).last?.order ?? 0
        
        if(state) {
            let fetchRequest: NSFetchRequest<Stock> = Stock.getSortedFetchRequest()
            fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
            
            if let stk = try? PersistentService.context.fetch(fetchRequest).first, !stk.onWatchlist {
                stk.onWatchlist = true
            } else {
                FMPquery.getProfile(symbol: symbol) { (tick, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl, cmpe) in
                    let newStock = Stock(context: PersistentService.context)
                    newStock.symbol = tick
                    newStock.companyName = cmpn
                    newStock.companyDescription = cmpd
                    newStock.companyCEO = cmpc
                    newStock.companyIndustry = cmpi
                    newStock.companyWebsite = cmpw
                    newStock.companyLogoURL = cmpl
                    newStock.companyEmployees = cmpe
                    newStock.sharesOwned = 0
                    newStock.onWatchlist = true
                    
                    if let last_order = last_order {
                        newStock.order = last_order + 1
                    }
                
                    PersistentService.saveContext()
                }
                
                UserDefaults.standard.set(false, forKey: "watchlistSet")
            }
        } else if !state {
            let fetchRequest: NSFetchRequest<Stock> = Stock.getSortedFetchRequest()
            fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
            do {
                let result = try PersistentService.context.fetch(fetchRequest)
                guard let stk = result.first else { return }
                
                if stk.sharesOwned <= 0 {
                    PersistentService.context.delete(stk)
                } else {
                    stk.onWatchlist = false
                }
                
                PersistentService.saveContext()
                
                UserDefaults.standard.set(false, forKey: "watchlistSet")
            } catch { print(error) }
        }
    }
    
    func setupCell(ticker: String) {
        symbol = ticker
        
        let fetchRequest: NSFetchRequest<Stock> = Stock.getSortedFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", ticker)
    
        do {
            let result = try PersistentService.context.fetch(fetchRequest)

            if let stk = result.first {
                companyNameLabel.text = stk.companyName
                
                if stk.onWatchlist {
                    saveButton.setSelected(selected: true, animated: false)
                }
            } else {
                FMPquery.getProfile(symbol: symbol) { [weak self] (tick, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl, cmpe) in
                    self?.companyNameLabel.text = cmpn
                }
            }
        } catch { print(error) }
    }

}

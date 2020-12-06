//
//  InformationCell.swift
//  Sample
//
//  Created by Aniruddha Prabhu on 6/21/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class InformationCell: UICollectionViewCell {
    
    var ticker = ""
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyCEO: UILabel!
    @IBOutlet weak var companyIndustry: UILabel!
    @IBOutlet weak var companyWebsite: UILabel!
    
    func setupCell(ticker: String) {
        let fetchRequest: NSFetchRequest<Stock> = Stock.getSortedFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", ticker)
        
        do {
            let result = try PersistentService.context.fetch(fetchRequest)
            
            if(result.count > 0) {
                guard let currentStock = result.first else { return }
                
                companyName.text = currentStock.companyName
                companyIndustry.text = currentStock.companyIndustry
                companyCEO.text = currentStock.companyCEO
                companyWebsite.text = currentStock.companyWebsite
                
            } else {
                FMPquery.getProfile(symbol: ticker) { (tick, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl) in
                    
                    self.companyName.text = cmpn
                    self.companyIndustry.text = cmpi
                    self.companyCEO.text = cmpc
                    self.companyWebsite.text = cmpw
                }
            }
        } catch { print(error) }
    }
}

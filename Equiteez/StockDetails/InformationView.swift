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

class InformationView: UIView {
    
    var ticker = ""
    
    @IBOutlet weak var companyIndustry: UILabel!
    @IBOutlet weak var companyCEO: UILabel!
    @IBOutlet weak var companyEmployees: UILabel!
    @IBOutlet weak var companyWebsite: UILabel!
    
    func setupCell(ticker: String) {
        let fetchRequest: NSFetchRequest<Stock> = Stock.getSortedFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", ticker)
        
        do {
            let result = try PersistentService.context.fetch(fetchRequest)
            
            if(result.count > 0) {
                guard let currentStock = result.first else { return }
                
                companyIndustry.text = currentStock.companyIndustry
                companyCEO.text = currentStock.companyCEO
                companyEmployees.text = String(currentStock.companyEmployees)
                companyWebsite.text = currentStock.companyWebsite
                
            } else {
                FMPquery.getProfile(symbol: ticker) { [weak self] (tick, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl, cmpe) in
                    
                    self?.companyIndustry.text = cmpi
                    self?.companyCEO.text = cmpc
                    self?.companyEmployees.text = String(cmpe)
                    self?.companyWebsite.text = cmpw
                }
            }
        } catch { print(error) }
    }
}

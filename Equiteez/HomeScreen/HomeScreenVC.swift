//
//  ViewController.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/7/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak var continueBTN: UIButton!
   
    @IBAction func enterApp(_ sender: Any) {
        performSegue(withIdentifier: "enterApp", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueBTN.layer.cornerRadius = continueBTN.frame.height / 2
        
//        let dg = DateGrouping()
//        dg.resetNetShares()
//        dg.getNetShares()
        
//        do {
//            let dg = DateGrouping()
//            var trades = try PersistentService.context.fetch(Trade.getSortedFetchRequest()).reversed() as Array
//
//            var fmt = DateFormatter()
//            fmt.dateFormat = "MM-dd-yyyy HH:mm:ss Z"
//            fmt.timeZone = TimeZone(abbreviation: "PST")
//            let tradesByTicker = dg.groupedTradesByTicker(transactions: trades)
//
//            for i in tradesByTicker.keys {
//                for j in 0..<tradesByTicker[i]!.count {
//
//                    if j == 0 {
//                        tradesByTicker[i]![j].netShares = tradesByTicker[i]![j].shareAmount
//                    } else if tradesByTicker[i]![j].type == "Buy" {
//                        tradesByTicker[i]![j].netShares = tradesByTicker[i]![j - 1].netShares + tradesByTicker[i]![j].shareAmount
//                    } else if tradesByTicker[i]![j].type == "Sell" {
//                        tradesByTicker[i]![j].netShares = tradesByTicker[i]![j - 1].netShares - tradesByTicker[i]![j].shareAmount
//                    }
//                }
//            }
//
//            for t in trades {
//                t.netShares = -1
//
//                print("ticker: \(t.ticker), type: \(t.type), shareamt: \(t.shareAmount), netshares: \(t.netShares), date: \(fmt.string(from: Date(timeIntervalSince1970: t.dateAcquired)))")
//            }
//
//            PersistentService.saveContext()
//
//            for i in tradesByTicker.keys {
//                for j in 0..<tradesByTicker[i]!.count {
//                    print("ticker: \(tradesByTicker[i]![j].ticker), type: \(tradesByTicker[i]![j].type), shareamt: \(tradesByTicker[i]![j].shareAmount), netshares: \(tradesByTicker[i]![j].netShares), date: \(fmt.string(from: Date(timeIntervalSince1970: tradesByTicker[i]![j].dateAcquired)))")
//                }
//            }
//        } catch { print(error) }
    }
}


//
//  TradeHistoryVC.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 12/16/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit
import CoreData
import SPStorkController
import SPFakeBar

class TradeHistoryVC: UIViewController {
    var trades = [Trade]()
    let fakenavbar = SPFakeBarView(style: .stork)
    @IBOutlet weak var tradesTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            trades = try PersistentService.context.fetch(Trade.getSortedFetchRequest())
            
        } catch { print(error) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tradesTableView.delegate = self
        tradesTableView.dataSource = self
        tradesTableView.register(UINib(nibName: "TradeHistoryCell", bundle: nil), forCellReuseIdentifier: "thc")
    }
    
    func setupShadow(view: UITableViewCell) -> UITableViewCell {
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        
        return view
    }
}

extension TradeHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thc") as! TradeHistoryCell
        let trade = trades[indexPath.row]
        
        cell.setup(ticker: trade.ticker, transactionType: trade.type, transactionShares: Int(trade.shareAmount), transactionPrice: trade.sharePrice * Double(trade.shareAmount), transactionDate: trade.dateAcquired)
        
        return cell
    }
}

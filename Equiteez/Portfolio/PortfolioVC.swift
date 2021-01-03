//
//  PortfolioVC.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 12/5/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit
import CoreData
import Charts
import SPStorkController
import SPFakeBar

class PortfolioVC: UIViewController {
    
    var balances = [Transfer]()
    var ownedStocks = [Stock]()
    var crp = [Double]()
    
    @IBOutlet weak var portfolioValueLabel: UILabel!
    @IBOutlet weak var fundsLabel: UILabel!
    @IBOutlet weak var portfolioTableView: UITableView!
    @IBAction func viewTradeHistory(_ sender: Any) {
        performSegue(withIdentifier: "gotoTradeHistory", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            balances = try PersistentService.context.fetch(Transfer.getSortedFetchRequest())
            if let walletBalance = balances.first?.walletBalance {
                fundsLabel.text = " $\(String(format: "%.2f", walletBalance))"
            }
            
            ownedStocks = try PersistentService.context.fetch(Stock.getSortedFetchRequest())
            ownedStocks = ownedStocks.filter({$0.sharesOwned != 0})
            
            crp.removeAll()
            let dg = DispatchGroup()
            for s in ownedStocks {
                dg.enter()
                FMPquery.getCurrentPrice(symbol: s.symbol!) { [weak self] (price) in
                    self?.crp.append(price * Double(s.sharesOwned))
                    dg.leave()
                }
            }
            
            dg.notify(queue: DispatchQueue.global()) {
                print(self.crp.reduce(0, +))
                
                DispatchQueue.main.async {
                    self.portfolioValueLabel.text = "$\(String(format: "%.2f", self.crp.reduce(0, +)))"
                }
            }
            
            portfolioTableView.reloadData()
        } catch { print(error) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
        portfolioTableView.register(UINib(nibName: "PortfolioStockCell", bundle: nil), forCellReuseIdentifier: "ptfc")
    }
}

extension PortfolioVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ownedStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ptfc") as! PortfolioStockCell
        let stk = ownedStocks[indexPath.row]
        
        cell.setup(ticker: stk.symbol!, sharesOwned: stk.sharesOwned)
        
        return cell
    }
}

class TradeHistorySegue: UIStoryboardSegue {
    public var transitioningDelegate = SPStorkTransitioningDelegate()
    
    override func perform() {
        transitioningDelegate.customHeight = 700
        
        destination.transitioningDelegate = transitioningDelegate
        destination.modalPresentationStyle = .custom
        super.perform()
    }
}

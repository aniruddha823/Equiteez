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
    var dates = [String]()
    var currentValue: Double = -1
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var portfolioValueLabel: UILabel!
    @IBOutlet weak var fundsLabel: UILabel!
    @IBOutlet weak var portfolioGraph: LineChartView!
    @IBOutlet weak var portfolioPercentChange: UILabel!
    @IBOutlet weak var portfolioTableView: UITableView!
    @IBAction func viewTradeHistory(_ sender: Any) {
        performSegue(withIdentifier: "gotoTradeHistory", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let format = DateFormatter()
            format.dateStyle = .long
            format.timeStyle = .none
            dateLabel.text = "\(format.string(from: Date()))"
            
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
//                print(self.crp.reduce(0, +))
                
                DispatchQueue.main.async {
                    let total = self.crp.reduce(0, +)
                    self.portfolioValueLabel.text = "$\(String(format: "%.2f", total))"
                    self.currentValue = total
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
        portfolioGraph.delegate = self
        
        portfolioPercentChange.layer.masksToBounds = true
        portfolioPercentChange.layer.cornerRadius = portfolioPercentChange.frame.height / 2
        
        do {
            let grouping = try DateGrouping()
//            grouping.getPostTransactionBalances()
            grouping.getDateRange(daysBack: 30)
            grouping.getWalletTimeline()
            let timeline = grouping.getTradeTimeline()

            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            fmt.timeZone = TimeZone(abbreviation: "PST")

            var values = [Double]()

            let dg2 = DispatchGroup()
            for ticker in grouping.tickerSet {
                let x = timeline.map { $0.shareList[ticker]! }

                dg2.enter()
                FMPquery.getMChart(symbol: ticker, datefrom: fmt.string(from: grouping.dateStart), dateto: fmt.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                        )) { mp, mpct, mpd in
                            self.dates = mpd

                    for i in stride(from: 0, to: mp.count, by: 1) {
                        let transactionPrice = mp[i] * Double(x[i])

                        if i < values.count {
                            values[i] += transactionPrice
                        } else {
                            values.append(transactionPrice)
                        }
                    }

                    dg2.leave()
                }
            }

            dg2.notify(queue: DispatchQueue.global()) {

                DispatchQueue.main.async {
                    var lineChartEntries = [ChartDataEntry]()

                    for i in stride(from: 0, to: values.count, by: 1) {
                        let day = ChartDataEntry(x: Double(i), y: values[i] + timeline[i].eodBalance)
                        lineChartEntries.append(day)
                    }

                    ViewAppearance.setupLineGraphView(lineChartView: self.portfolioGraph, lce: lineChartEntries)

                    NumDateFormatter.formatPercent(percentage: ((values.last! / values.first!) - 1) * 100, label: self.portfolioPercentChange)
                }
            }
        } catch { print(error) }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PortfolioVC: UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ownedStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ptfc") as! PortfolioStockCell
        let stk = ownedStocks[indexPath.row]
        
        cell.setup(ticker: stk.symbol!, sharesOwned: stk.sharesOwned)
        
        return cell
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .none
        dateLabel.text = "\(NumDateFormatter.convertDate(dateString: dates[Int(entry.x)]))"
        
        portfolioValueLabel.text = String(format: "%.2f", entry.y)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .none
        dateLabel.text = "\(format.string(from: Date()))"
        
        portfolioValueLabel.text = "$\(String(format: "%.2f", currentValue))"
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

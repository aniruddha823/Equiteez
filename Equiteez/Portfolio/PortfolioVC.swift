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
    var dg = DispatchGroup()
    
    var balances = [Transfer]()
    var ownedStocks = [Stock]()
    var crp = [Double]()
    var dates = [String]()
    var currentValue: Double = -1
    var charts: [String : [ChartDataEntry]]?
    var percentages: [String : Double]?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var portfolioValueTypeLabel: UILabel!
    @IBOutlet weak var portfolioValueLabel: UILabel!
    @IBOutlet weak var fundsLabel: UILabel!
    @IBOutlet weak var portfolioGraph: LineChartView!
    @IBOutlet weak var portfolioPercentChange: UILabel!
    @IBOutlet weak var portfolioTableView: UITableView!
    
    @IBAction func refreshPortfolio(_ sender: Any) {
        self.view.makeToast(message: "Updating portfolio...", duration: 1.0, position: .center)
    }
    
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
            
            let portfolioIsSet = UserDefaults.standard.bool(forKey: "portfolioIsSet")
            let chartIsSet = UserDefaults.standard.bool(forKey: "chartIsSet")
            if !portfolioIsSet && !chartIsSet {
                print("if 1")
                resetCellData()
                updateOnStart()
            } else if portfolioIsSet && !chartIsSet {
                print("if 2")
                resetCellData()
                updateOnSettingChange()
            } else if !portfolioIsSet && chartIsSet {
                print("if 3")
                resetCellData()
                updateOnBuySell()
            }
        } catch { print(error) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        portfolioTableView.delegate = self
//        portfolioTableView.dataSource = self
//        portfolioTableView.register(UINib(nibName: "PortfolioStockCell", bundle: nil), forCellReuseIdentifier: "ptfc")
        
        portfolioGraph.delegate = self
        portfolioPercentChange.layer.masksToBounds = true
        portfolioPercentChange.layer.cornerRadius = portfolioPercentChange.frame.height / 2
    }
    
    private func updateOnStart() {
        do {
            let grouping = try DateGrouping()
            grouping.getDateRange(daysBack: 30)
            grouping.getWalletTimeline()
            let timeline = grouping.getTradeTimeline()

            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            fmt.timeZone = TimeZone(abbreviation: "PST")

            var values = [Double]()
            var charts2 = [String : [ChartDataEntry]]()
            var percentages2 = [String : Double]()
            
            for i in 0..<ownedStocks.count {
                dg.enter()
                FMPquery.getCurrentPrice(symbol: ownedStocks[i].symbol!) { [unowned self] (price) in
                    self.crp[i] = price * Double(self.ownedStocks[i].sharesOwned)
                    self.dg.leave()
                }
            }

            for ticker in grouping.tickerSet {
                let x = timeline.map { $0.shareList[ticker]! }

                dg.enter()
                FMPquery.getMChart(symbol: ticker, datefrom: fmt.string(from: grouping.dateStart), dateto: fmt.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                        )) { [unowned self] mp, mpct, mpd in
                            self.dates = mpd

                    for i in stride(from: 0, to: mp.count, by: 1) {
                        let transactionPrice = mp[i] * Double(x[i])

                        if i < values.count {
                            values[i] += transactionPrice
                        } else {
                            values.append(transactionPrice)
                        }
                    }

                    self.dg.leave()
                }
            }

            dg.notify(queue: DispatchQueue.global()) {
                DispatchQueue.main.async {
                    self.portfolioTableView.delegate = self
                    self.portfolioTableView.dataSource = self
                    self.portfolioTableView.register(UINib(nibName: "PortfolioStockCell", bundle: nil), forCellReuseIdentifier: "ptfc")
                    self.portfolioTableView.reloadData()
                    print("crp: \(self.crp)")
                    let total = self.crp.reduce(0, +)
                    
                    var lineChartEntries = [ChartDataEntry]()
                    let svalPercentage = ((values.last! / values.first!) - 1) * 100
                    let totalPercentage = (((values.last! + timeline.last!.eodBalance) / (values.first! + timeline.first!.eodBalance)) - 1) * 100
                    
                    for i in stride(from: 0, to: values.count, by: 1) {
                        let day = ChartDataEntry(x: Double(i), y: values[i])
                        lineChartEntries.append(day)
                    }
                    charts2["sval"] = lineChartEntries; percentages2["sval"] = svalPercentage
                    lineChartEntries.removeAll()
                    
                    for i in stride(from: 0, to: values.count, by: 1) {
                        let day = ChartDataEntry(x: Double(i), y: values[i] + timeline[i].eodBalance)
                        lineChartEntries.append(day)
                    }
                    charts2["total"] = lineChartEntries; percentages2["total"] = totalPercentage
                    
                    self.charts = charts2
                    self.percentages = percentages2
                    
                    if let returnTypeSelected = UserDefaults.standard.string(forKey: "returnsType") {
                        
                        if returnTypeSelected == "sval" {
                            self.portfolioValueTypeLabel.text = "Value of Shares"
                            self.portfolioValueLabel.text = "$\(String(format: "%.2f", total))"
                            self.currentValue = total
                            
                            ViewAppearance.setupLineGraphView(lineChartView: self.portfolioGraph, lce: charts2["sval"]!)

                            NumDateFormatter.formatPercent(percentage: svalPercentage, label: self.portfolioPercentChange)
                        } else if returnTypeSelected == "total" {
                            self.portfolioValueTypeLabel.text = "Net Assets"
                            self.portfolioValueLabel.text = "$\(String(format: "%.2f", total + (self.balances.first?.walletBalance ?? 0)))"
                            self.currentValue = total + (self.balances.first?.walletBalance ?? 0)
                            
                            ViewAppearance.setupLineGraphView(lineChartView: self.portfolioGraph, lce: charts2["total"]!)

                            NumDateFormatter.formatPercent(percentage: totalPercentage, label: self.portfolioPercentChange)
                        }
                    } else {
                        self.portfolioValueTypeLabel.text = "Value of Shares"
                        self.portfolioValueLabel.text = "$\(String(format: "%.2f", total))"
                        self.currentValue = total

                        ViewAppearance.setupLineGraphView(lineChartView: self.portfolioGraph, lce: charts2["sval"]!)

                        NumDateFormatter.formatPercent(percentage: svalPercentage, label: self.portfolioPercentChange)
                    }
                    
                    UserDefaults.standard.set(true, forKey: "chartIsSet")
                    UserDefaults.standard.set(true, forKey: "portfolioIsSet")
                }
            }
        } catch { print(error) }
    }
    
    private func updateOnBuySell() {
        for i in 0..<ownedStocks.count {
            dg.enter()
            FMPquery.getCurrentPrice(symbol: ownedStocks[i].symbol!) { [unowned self] (price) in
                self.crp[i] = price * Double(self.ownedStocks[i].sharesOwned)
                self.dg.leave()
            }
        }
                
        dg.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                self.portfolioTableView.delegate = self
                self.portfolioTableView.dataSource = self
                self.portfolioTableView.register(UINib(nibName: "PortfolioStockCell", bundle: nil), forCellReuseIdentifier: "ptfc")
                self.portfolioTableView.reloadData()
                let total = self.crp.reduce(0, +)
                        
                if let returnTypeSelected = UserDefaults.standard.string(forKey: "returnsType") {
                    if returnTypeSelected == "sval" {
                        self.portfolioValueTypeLabel.text = "Value of Shares"
                        self.portfolioValueLabel.text = "$\(String(format: "%.2f", total))"
                        self.currentValue = total
                                
                        if let charts = self.charts, let percentages = self.percentages {
                            NumDateFormatter.formatPercent(percentage: percentages["sval"]!, label: self.portfolioPercentChange)
                        }
                    } else if returnTypeSelected == "total" {
                        self.portfolioValueTypeLabel.text = "Net Assets"
                        self.portfolioValueLabel.text = "$\(String(format: "%.2f", total + (self.balances.first?.walletBalance ?? 0)))"
                        self.currentValue = total + (self.balances.first?.walletBalance ?? 0)
                                
                        if let charts = self.charts, let percentages = self.percentages {
                            NumDateFormatter.formatPercent(percentage: percentages["total"]!, label: self.portfolioPercentChange)
                        }
                    }
                } else {
                    self.portfolioValueTypeLabel.text = "Value of Shares"
                    self.portfolioValueLabel.text = "$\(String(format: "%.2f", total))"
                    self.currentValue = total
                            
                    if let charts = self.charts, let percentages = self.percentages {
                                NumDateFormatter.formatPercent(percentage: percentages["sval"]!, label: self.portfolioPercentChange)
                    }
                }
                        
                UserDefaults.standard.set(true, forKey: "portfolioIsSet")
            }
        }
    }
    
    private func updateOnSettingChange() {
        for i in 0..<ownedStocks.count {
            dg.enter()
            FMPquery.getCurrentPrice(symbol: ownedStocks[i].symbol!) { [unowned self] (price) in
                self.crp[i] = price * Double(self.ownedStocks[i].sharesOwned)
                self.dg.leave()
            }
        }
        
        dg.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                let total = self.crp.reduce(0, +)
                
                if let returnTypeSelected = UserDefaults.standard.string(forKey: "returnsType") {
                    if returnTypeSelected == "sval" {
                        self.portfolioValueTypeLabel.text = "Value of Shares"
                        self.portfolioValueLabel.text = "$\(String(format: "%.2f", total))"
                        self.currentValue = total
                        
                        if let charts = self.charts, let percentages = self.percentages {
                            ViewAppearance.setupLineGraphView(lineChartView: self.portfolioGraph, lce: charts["sval"]!)
                            NumDateFormatter.formatPercent(percentage: percentages["sval"]!, label: self.portfolioPercentChange)
                            
                        }
                    } else if returnTypeSelected == "total" {
                        self.portfolioValueTypeLabel.text = "Net Assets"
                        self.portfolioValueLabel.text = "$\(String(format: "%.2f", total + (self.balances.first?.walletBalance ?? 0)))"
                        self.currentValue = total + (self.balances.first?.walletBalance ?? 0)
                        
                        if let charts = self.charts, let percentages = self.percentages {
                            ViewAppearance.setupLineGraphView(lineChartView: self.portfolioGraph, lce: charts["total"]!)
                            NumDateFormatter.formatPercent(percentage: percentages["total"]!, label: self.portfolioPercentChange)
                        }
                    }
                } else {
                    self.portfolioValueTypeLabel.text = "Value of Shares"
                    self.portfolioValueLabel.text = "$\(String(format: "%.2f", total))"
                    self.currentValue = total
                    
                    if let charts = self.charts, let percentages = self.percentages {
                        ViewAppearance.setupLineGraphView(lineChartView: self.portfolioGraph, lce: charts["sval"]!)
                        NumDateFormatter.formatPercent(percentage: percentages["sval"]!, label: self.portfolioPercentChange)
                    }
                }
                
                UserDefaults.standard.set(true, forKey: "chartIsSet")
            }
        }
    }
    
    private func resetCellData() {
        crp.removeAll()
        crp = Array(repeating: -1, count: ownedStocks.count)
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
        
        cell.setup(ticker: stk.symbol!, sharesOwned: stk.sharesOwned, price: crp[indexPath.row])
        
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
        transitioningDelegate.showIndicator = false
        
        destination.transitioningDelegate = transitioningDelegate
        destination.modalPresentationStyle = .custom
        super.perform()
    }
}

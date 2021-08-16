//
//  StockMainVC.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/7/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit
import SPStorkController
import CoreData
import Charts

class StocksMainVC: UIViewController {
    
    var savedStocks = [Stock]()
    var passingTicker = ""
    var prices: [Double]?
    var percentages: [Double]?
    var volumes: [Double]?
    
    let dg = DispatchGroup()
    let x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26]
    let y = [60.53, 60.19, 59.90, 60.07, 60.08, 60.03, 59.79, 59.56, 59.70, 59.82, 60.10, 60.53, 60.65, 60.77, 60.80, 60.64, 60.63, 60.68, 60.59, 60.51, 60.35, 60.26, 60.32, 60.4, 60.5, 60.85, 60.63]
    var lineChartEntries = [ChartDataEntry]()
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var stocksTableView: UITableView!
    {
        didSet {
            refreshSavedStocks()
        }
    }
    
    @IBAction func searchStock(_ sender: Any) {
        performSegue(withIdentifier: "gotoSearch", sender: self)
    }
    
    @IBAction func editSavedStocks(_ sender: UIButton) {
        self.stocksTableView.isEditing = !self.stocksTableView.isEditing
        self.stocksTableView.isEditing ? editButton.setTitle("Done", for: .normal) : editButton.setTitle("Edit", for: .normal)
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        if let svc = segue.source as? SearchStockVC {
            passingTicker = svc.passedTicker
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "gotoSegmented", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoSegmented" {
            let dvc = segue.destination as! StockSegmentedVC
            dvc.ticker = passingTicker
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let boolcheck = UserDefaults.standard.bool(forKey: "watchlistSet")
        
        refreshSavedStocks()
        
        if let index = stocksTableView.indexPathForSelectedRow {
            self.stocksTableView.deselectRow(at: index, animated: false)
        }
        
        if !boolcheck {
            resetCellData()
            
            for i in 0..<savedStocks.count {
                dg.enter()
                FMPquery.getCurrentPrice(symbol: self.savedStocks[i].symbol!) {
                    [unowned self] (price) in
                    self.prices?[i] = price
                        
                    self.dg.leave()
                }

                dg.enter()
                FMPquery.getProfile(symbol: self.savedStocks[i].symbol!) {
                    [unowned self] (ticker, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl, cmpe) in
                    self.percentages?[i] = Double(pchg) ?? 0
                    self.volumes?[i] = avgv
                        
                    self.dg.leave()
                }
            }

            dg.notify(queue: .main) {
                DispatchQueue.main.async {
                    self.stocksTableView.delegate = self
                    self.stocksTableView.dataSource = self
                    self.stocksTableView.register(UINib(nibName: "StockCell", bundle: nil), forCellReuseIdentifier: "stkc")
                    self.stocksTableView.reloadData()
                }
            }
            
            UserDefaults.standard.set(true, forKey: "watchlistSet")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(named: "text-primary")
        
        for i in stride(from: 0, to: x.count, by: 1) {
            let day = ChartDataEntry(x: Double(x[i]), y: y[i])
            lineChartEntries.append(day)
        }
        
        let boolcheck = UserDefaults.standard.bool(forKey: "watchlistSet")
        
        if !boolcheck {
            resetCellData()
            
            for i in 0..<savedStocks.count {
                dg.enter()
                FMPquery.getCurrentPrice(symbol: self.savedStocks[i].symbol!) {
                    [unowned self] (price) in
                    self.prices?[i] = price
                        
                    self.dg.leave()
                }

                dg.enter()
                FMPquery.getProfile(symbol: self.savedStocks[i].symbol!) {
                    [unowned self] (ticker, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl, cmpe) in
                    self.percentages?[i] = Double(pchg) ?? 0
                    self.volumes?[i] = avgv
                        
                    self.dg.leave()
                }
            }

            dg.notify(queue: .main) {
                DispatchQueue.main.async {
                    self.stocksTableView.delegate = self
                    self.stocksTableView.dataSource = self
                    self.stocksTableView.register(UINib(nibName: "SavedStockCell", bundle: nil), forCellReuseIdentifier: "stkc")
                    self.stocksTableView.reloadData()
                }
            }
            
            UserDefaults.standard.set(true, forKey: "watchlistSet")
        }
    }
    
    func refreshSavedStocks() {
        do {
            savedStocks = try PersistentService.context.fetch(Stock.getSortedFetchRequest())
            savedStocks = savedStocks.filter({$0.onWatchlist})
        } catch { print(error) }
    }
    
    func saveItems() {
        PersistentService.saveContext()
    }
    
    func resetCellData() {
        prices?.removeAll(); percentages?.removeAll(); volumes?.removeAll()
        prices = Array(repeating: -1, count: savedStocks.count)
        percentages = Array(repeating: -1, count: savedStocks.count)
        volumes = Array(repeating: -1, count: savedStocks.count)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        AppDelegate.AppUtility.lockOrientation(.all)
//    }
}

extension StocksMainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stkc") as! StockCell
        let stk = savedStocks[indexPath.row]
        
        cell.setupAppearance()
        cell.setupCellText(name: stk.companyName!, ticker: stk.symbol!)
        cell.setupCellNumbers(price: prices![indexPath.row], percentage: percentages![indexPath.row], volume: volumes![indexPath.row])
//        cell.setupCellNumbers2(ticker: stk.symbol!)
        cell.setLogo(logoURL: stk.companyLogoURL!)
        
        
//        cell.layer.cornerRadius = 10
//        cell.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        cell.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
//        cell.layer.shadowRadius = 3
//        cell.layer.shadowOpacity = 1
//        cell.layer.masksToBounds = true
        
        ViewAppearance.setupMiniLineGraphView(lineChartView: cell.priceGraph, lce: lineChartEntries)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symbol = savedStocks[indexPath.row].symbol
        passingTicker = symbol!.uppercased()
        
        performSegue(withIdentifier: "gotoSegmented", sender: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let deleted_index = indexPath.item
                
                for i in deleted_index + 1...savedStocks.count - 1 {
                    savedStocks[i].order -= 1
                }
                
                PersistentService.context.delete(savedStocks[deleted_index])
                saveItems()
                refreshSavedStocks()
                stocksTableView.reloadData()
            }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source_index = sourceIndexPath.item
        let destination_index = destinationIndexPath.item

        if source_index < destination_index {
            var starting_index = source_index
            var starting_order = savedStocks[source_index].order - 1
            
            while starting_index <= destination_index {
                savedStocks[starting_index].order = starting_order
                starting_order += 1
                starting_index += 1
            }
            
            savedStocks[source_index].order = starting_order

        } else if destination_index < source_index {
            var starting_index = source_index
            var starting_order = savedStocks[source_index].order + 1
            
            while starting_index >= destination_index {
                savedStocks[starting_index].order = starting_order
                starting_order -= 1
                starting_index -= 1
            }
            
            savedStocks[source_index].order = starting_order
        }

        saveItems()
        refreshSavedStocks()
        stocksTableView.reloadData()
    }
}

class SearchStockSegue: UIStoryboardSegue {
    
    public var transitioningDelegate = SPStorkTransitioningDelegate()
    
    override func perform() {
        transitioningDelegate.customHeight = 700
        transitioningDelegate.showIndicator = false
        
        destination.transitioningDelegate = transitioningDelegate
        destination.modalPresentationStyle = .custom
        super.perform()
    }
}

// Code to delete all stock objects
//@IBAction func deleteAll(_ sender: Any) {
//    let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
//    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//    do {
//        try PersistentService.context.execute(batchDeleteRequest)
//        refreshSavedStocks()
//        saveItems()
//
//        print("all records deleted")
//    } catch { print("deleting failed") }
//
//    do {
//        let cnt = try PersistentService.context.fetch(Product.fetchRequest()).count
//        print("count after deleting: \(cnt)")
//    } catch {}
//
//    stocksTableView.reloadData()
//}

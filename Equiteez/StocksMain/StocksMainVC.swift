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

class StocksMainVC: UIViewController {
    
    var savedStocks = [Stock]()
    var passingTicker = ""
    var prices: [Double]?
    var percentages: [Double]?
    var volumes: [Double]?
    
    let dg = DispatchGroup()
    
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
                    self.stocksTableView.register(UINib(nibName: "StockCell", bundle: nil), forCellReuseIdentifier: "stkc")
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
        
        cell.setupCellText(name: stk.companyName!, ticker: stk.symbol!)
        cell.setupCellNumbers(price: prices![indexPath.row], percentage: percentages![indexPath.row], volume: volumes![indexPath.row])
//        cell.setupCellNumbers2(ticker: stk.symbol!)
        cell.setLogo(logoURL: stk.companyLogoURL!)
        
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

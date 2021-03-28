//
//  TradeStock.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 12/19/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit
import SPStorkController
import SPFakeBar
import CoreData

class TradeScreenVC: UIViewController {
    let fakenavbar = SPFakeBarView(style: .stork)
    var ticker = ""
    var savedStock: Stock?
    
    @IBOutlet weak var stockTickerLabel: UILabel!
    @IBOutlet weak var transactionTypeControl: UISegmentedControl!
    
    @IBOutlet weak var sharePriceLabel: UILabel!
    @IBOutlet weak var shareAmountLabel: UILabel!
    @IBOutlet weak var transactionPriceLabel: UILabel!
    
    @IBOutlet weak var shareAmountField: UITextField!
    @IBOutlet weak var shareAmountStepper: UIStepper!
    
    @IBOutlet weak var walletFundsLabel: UILabel!
    @IBOutlet weak var sharesOwnedLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelTrade(_ sender: Any) {
        print("transaction canceled")
        
        // dismiss view
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confirmTrade(_ sender: Any) {
        print("transaction confirmed")
        
        guard let sharePrice = Double(sharePriceLabel.text!.split(separator: "$")[0]) else { return }
        guard let transactionPrice = Double(transactionPriceLabel.text!.split(separator: "$")[1]) else { return }
        guard let availableBalance = Double(walletFundsLabel.text!.split(separator: "$")[0]) else { return }
        let shareAmount = Int(shareAmountStepper.value)
        let currentDate = Double(Date().timeIntervalSince1970)
        var latestNetShares: Int64?
        
        do {
            let latestTrade = try PersistentService.context.fetch(Trade.getSortedFetchRequest()).filter { $0.ticker == ticker }.first
            
            if let latestTrade = latestTrade {
                latestNetShares = latestTrade.netShares
            }
            
            
        } catch { print("failed") }
        
        // Buying
        if transactionTypeControl.selectedSegmentIndex == 0 {
            
            // Insufficient Funds
            if transactionPrice > availableBalance {
                self.view.makeToast(message: "Insufficient funds! Please reduce the number of shares to afford this transaction.", duration: 2.0, position: .center)
            } else {
                
                // Buying shares for stock that was saved first. Create trade+transfer
                // objects, fetch stock properties, save context.
                if let savedStock = savedStock {
                    let trade = Trade(context: PersistentService.context)
                    trade.type = "Buy"
                    trade.ticker = ticker
                    trade.sharePrice = sharePrice
                    trade.shareAmount = Int64(shareAmount)
                    trade.dateAcquired = currentDate
                    
                    if let latestNetShares = latestNetShares {
                        trade.netShares = latestNetShares + Int64(shareAmount)
                    } else {
                        trade.netShares = Int64(shareAmount)
                    }
                    
                    let transfer = Transfer(context: PersistentService.context)
                    print("cb: \(availableBalance), tp: \(transactionPrice)")
                    transfer.walletBalance = availableBalance - transactionPrice
                    transfer.dateUpdated = currentDate
                    
                    savedStock.sharesOwned += shareAmount
                    
                    PersistentService.saveContext()
                    dismiss(animated: true, completion: nil)
                }
                
                // Buying shares for stock that wasn't saved first. Create new trade+transfer
                // objects, fetch stock properties, save context.
                else {
                    let trade = Trade(context: PersistentService.context)
                    trade.type = "Buy"
                    trade.ticker = ticker
                    trade.sharePrice = sharePrice
                    trade.shareAmount = Int64(shareAmount)
                    trade.dateAcquired = currentDate
                    
                    if let latestNetShares = latestNetShares {
                        trade.netShares = latestNetShares + Int64(shareAmount)
                    } else {
                        trade.netShares = Int64(shareAmount)
                    }
                    
                    let transfer = Transfer(context: PersistentService.context)
                    print("cb: \(availableBalance), tp: \(transactionPrice)")
                    transfer.walletBalance = availableBalance - transactionPrice
                    transfer.dateUpdated = currentDate
                    
                    let last_order = try? PersistentService.context.fetch(Stock.getSortedFetchRequest()).last?.order ?? 0
                    
                    FMPquery.getProfile(symbol: ticker) { (tick, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl, cmpe) in
                        
                        let newStock = Stock(context: PersistentService.context)
                        newStock.symbol = tick
                        newStock.companyName = cmpn
                        newStock.companyDescription = cmpd
                        newStock.companyCEO = cmpc
                        newStock.companyIndustry = cmpi
                        newStock.companyWebsite = cmpw
                        newStock.companyLogoURL = cmpl
                        newStock.companyEmployees = cmpe
                        newStock.sharesOwned = shareAmount
                        newStock.onWatchlist = true
                        
                        if let last_order = last_order {
                            newStock.order = last_order + 1
                        }
                        
                        PersistentService.saveContext()
                    }
                    
                    PersistentService.saveContext()
                    dismiss(animated: true, completion: nil)
                }
            }
        }
        
        // Selling
        else if transactionTypeControl.selectedSegmentIndex == 1 {
            
            // Insufficient Shares
            if shareAmount > savedStock!.sharesOwned {
                self.view.makeToast(message: "Insufficient shares! The number of shares attempting to be sold is more than the number currently owned.", duration: 2.0, position: .center)
            }
            
            // Selling some or all shares
            else {
                let trade = Trade(context: PersistentService.context)
                trade.type = "Sell"
                trade.ticker = ticker
                trade.sharePrice = sharePrice
                trade.shareAmount = Int64(shareAmount)
                trade.dateAcquired = currentDate
                
                if let latestNetShares = latestNetShares {
                    trade.netShares = latestNetShares - Int64(shareAmount)
                } else {
                    trade.netShares = Int64(shareAmount)
                }
                
                let transfer = Transfer(context: PersistentService.context)
                transfer.walletBalance = availableBalance + transactionPrice
                transfer.dateUpdated = currentDate
                
                savedStock!.sharesOwned -= shareAmount
                
                PersistentService.saveContext()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let currentPrice = Double(sharePriceLabel.text!.split(separator: "$")[0])

        shareAmountLabel.text = "x \(Int(sender.value).description)"
        transactionPriceLabel.text = "= $\(String(format: "%.2f", currentPrice! * Double(sender.value)))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<Stock> = Stock.getSortedFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", ticker)
        
        // get saved stock object, disable sell if no shares owned
        do {
            let result = try PersistentService.context.fetch(fetchRequest)
            if result.count > 0 {
                savedStock = result.first!
                sharesOwnedLabel.text = String(savedStock!.sharesOwned)
                
                if savedStock?.sharesOwned == 0 {
                    transactionTypeControl.setEnabled(false, forSegmentAt: 1)
                }
            } else {
                transactionTypeControl.setEnabled(false, forSegmentAt: 1)
            }
        } catch { print(error) }
        
        // load current balance
        do {
            let result = try PersistentService.context.fetch(Transfer.getSortedFetchRequest())
            if let currentFunds = result.first {
                walletFundsLabel.text = "$\(String(format: "%.2f", currentFunds.walletBalance))"
            }
        } catch { print(error) }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stockTickerLabel.text = ticker
        
        shareAmountField.keyboardType = .numberPad
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
        // set share amount to 1
        shareAmountStepper.minimumValue = 1
        shareAmountStepper.maximumValue = Double.greatestFiniteMagnitude
        shareAmountStepper.autorepeat = true
        shareAmountLabel.text = "x \(Int(shareAmountStepper.value))"
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        confirmButton.layer.cornerRadius = confirmButton.frame.height / 2
        
        // fetch current share price, update initial labels
        FMPquery.getCurrentPrice(symbol: ticker) { [weak self] (price) in
            self?.sharePriceLabel.text = "$\(String(format: "%.2f", price))"
            self?.transactionPriceLabel.text = "= $\(String(format: "%.2f", price))"
        }
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
}

enum TransactionStatus {
    case insufficientFunds
    case insufficientShares
    case validBuy
    case validSell
}

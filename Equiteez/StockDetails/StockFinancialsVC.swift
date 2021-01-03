//
//  StockFinancialsVC.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 2/2/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit
import FSPagerView
import SwiftDataTables

class StockFinancialsVC: UIViewController {
    
    typealias BalanceSheets = [BalanceSheet]
    lazy var dataTable = makeDataTable()
    var ticker = ""
    var bs3 = BalanceSheets()
    
    @IBOutlet weak var financialStatementView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
        ticker = ticker.uppercased()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dataTable.delegate = self
//        dataTable.dataSource = self
        
        FMPquery.getBalanceSheet(symbol: ticker) { [weak self] (bs) in
            let bsar = try! JSONDecoder().decode(BalanceSheets.self, from: bs)
            self?.bs3 = bsar
            
            self?.financialStatementView.addSubview(self!.dataTable)
            NSLayoutConstraint.activate([
                self!.dataTable.topAnchor.constraint(equalTo: self!.financialStatementView.topAnchor),
                self!.dataTable.leadingAnchor.constraint(equalTo: self!.financialStatementView.leadingAnchor),
                self!.dataTable.bottomAnchor.constraint(equalTo: self!.financialStatementView.bottomAnchor),
                self!.dataTable.trailingAnchor.constraint(equalTo: self!.financialStatementView.trailingAnchor),
            ])
        }
    }
}

extension StockFinancialsVC {
    func makeDataTable() -> SwiftDataTable {
        let dataTable = SwiftDataTable(
            data: data(),
            headerTitles: columnHeaders(),
            options: setupTableConfig()        )

        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        return dataTable
    }
    
    func columnHeaders() -> [String] {
        return [""] + bs3.map({NumDateFormatter.getQuarterString(date: $0.date, period: $0.period)})
    }
    
    func processSheet(sheet: [[String]]) -> [[String]]{
        var finsheet = sheet
        let columns = ["Date", "Cash & Cash Equivalents", "Short-Term Investments", "Net Receivables", "Inventory", "Current Assets", "Net PP&E", "Long-Term Investments", "Non-Current Assets", "Total Assets", "Accounts Payable", "Short-Term Debt", "Deferred Revenue", "Current Liabilities", "Long-Term Debt", "Non-Current Liabilities", "Total Liabilities", "Common Stock", "Retained Earnings", "Total Stockholder Equity", "Total Debt"]
        finsheet.insert(columns, at: 0)
        
        return finsheet
    }

    func data() -> [[DataTableValueType]] {
        print()
        
        var sheet = matrixTranspose(processSheet(sheet: bs3.map({$0.rep})))
        return sheet.map {
            $0.compactMap (DataTableValueType.init)
        }
    }
    
    func setupTableConfig() -> DataTableConfiguration {
        var configuration = DataTableConfiguration()
        configuration.shouldShowFooter = false
        configuration.shouldShowSearchSection = false
        configuration.shouldSectionFootersFloat = false
        configuration.shouldContentWidthScaleToFillFrame = true
        
        return configuration
    }
    
    func matrixTranspose<T>(_ matrix: [[T]]) -> [[T]] {
        if matrix.isEmpty {return matrix}
        var result = [[T]]()
        for index in 0..<matrix.first!.count {
            result.append(matrix.map{$0[index]})
        }
        return result
    }
}

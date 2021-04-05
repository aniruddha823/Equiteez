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

enum StatementType {
    case balanceSheet
    case incomeStatement
    case cashFlowStatement
}

class StockFinancialsVC: UIViewController {
    
    typealias BalanceSheets = [BalanceSheet]; var bst = BalanceSheets();
    typealias IncomeStatements = [IncomeStatement]; var ist = IncomeStatements()
    typealias CashFlowStatements = [CashFlowStatement]; var cfst = CashFlowStatements()
    
//    lazy var dataTableBS = makeDataTableBS()
//    lazy var dataTableIS = makeDataTableIS()
//    lazy var dataTableCFS = makeDataTableCFS()
    
    var ticker = ""
    var tables = [SwiftDataTable]()
    var test = ["Balance Sheet", "Income Statement", "Cash Flow Statement"]
    
    let dg = DispatchGroup()
    
    @IBOutlet weak var financialStatementTitleView: FSPagerView!
    @IBOutlet weak var financialStatementView: FSPagerView!
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
        ticker = ticker.uppercased()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        financialStatementView.dataSource = self
//        financialStatementView.delegate = self
//        financialStatementView.register(UINib(nibName: "StatementPagerViewCell", bundle: .main), forCellWithReuseIdentifier: "fsc")
//        financialStatementView.transformer = FSPagerViewTransformer(type: .linear)


        dg.enter()
        FMPquery.getBalanceSheet(symbol: ticker) { [weak self] (bs) in
            let x = try! JSONDecoder().decode(BalanceSheets.self, from: bs)
            self?.bst = x

            let table = self!.makeDataTableBS()
            self?.tables.append(table)
            self!.dg.leave()
        }

        dg.enter()
        FMPquery.getIncomeStatement(symbol: ticker) { [weak self] (incst) in
            let x = try! JSONDecoder().decode(IncomeStatements.self, from: incst)
            self?.ist = x
            
            let table = self!.makeDataTableIS()
            self?.tables.append(table)
            self!.dg.leave()
        }

        dg.enter()
        FMPquery.getCashFlowStatement(symbol: ticker) { [weak self] (cft) in
            let x = try! JSONDecoder().decode(CashFlowStatements.self, from: cft)
            self?.cfst = x
            
            let table = self!.makeDataTableCFS()
            self?.tables.append(table)
            self!.dg.leave()
        }

        dg.notify(queue: .main) {
            self.financialStatementView.reloadData()
            self.financialStatementView.delegate = self
            self.financialStatementView.dataSource = self
            self.financialStatementView.register(UINib(nibName: "StatementPagerViewCell", bundle: .main), forCellWithReuseIdentifier: "fsc")
            self.financialStatementView.transformer = FSPagerViewTransformer(type: .linear)
            self.financialStatementView.isScrollEnabled = false
            
            self.financialStatementTitleView.reloadData()
            self.financialStatementTitleView.delegate = self
            self.financialStatementTitleView.dataSource = self
            self.financialStatementTitleView.register(UINib(nibName: "StatementTitleCell", bundle: .main), forCellWithReuseIdentifier: "fstc")
            self.financialStatementTitleView.transformer = FSPagerViewTransformer(type: .linear)
            self.financialStatementTitleView.bounces = false
        }
//
//        dataTable.delegate = self
//        dataTable.dataSource = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension StockFinancialsVC: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        if pagerView == financialStatementView {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "fsc", at: index) as! StatementPagerViewCell
            cell.contentView.isUserInteractionEnabled = false

            if index == 0 {
                cell.setup(table: tables[index])
            } else if index == 1 {
                cell.setup(table: tables[index])
            } else if index == 2 {
                cell.setup(table: tables[index])
            }

            return cell
        } else {
            let cell2 = pagerView.dequeueReusableCell(withReuseIdentifier: "fstc", at: index) as! StatementTitleCell

            if index == 0 {
                cell2.titleLabel.text = test[index]
            } else if index == 1 {
                cell2.titleLabel.text = test[index]
            } else if index == 2 {
                cell2.titleLabel.text = test[index]
            }

            return cell2
        }
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if pagerView == financialStatementTitleView {
            financialStatementView.scrollToItem(at: targetIndex, animated: true)
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        if pagerView == financialStatementView {
            return false
        } else { return true }
    }
}

extension StockFinancialsVC {
    func makeDataTableBS() -> SwiftDataTable {
        let dataTable = SwiftDataTable(
            data: data(type: .balanceSheet),
            headerTitles: columnHeaders(type: .balanceSheet),
            options: setupTableConfig())

        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.backgroundColor = UIColor(named: "background-primary")

        return dataTable
    }
        
    func makeDataTableIS() -> SwiftDataTable {
        let dataTable = SwiftDataTable(
            data: data(type: .incomeStatement),
            headerTitles: columnHeaders(type: .incomeStatement),
            options: setupTableConfig())

        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.backgroundColor = UIColor(named: "background-primary")

        return dataTable
    }
        
    func makeDataTableCFS() -> SwiftDataTable {
        let dataTable = SwiftDataTable(
            data: data(type: .cashFlowStatement),
            headerTitles: columnHeaders(type: .cashFlowStatement),
            options: setupTableConfig())

        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.backgroundColor = UIColor(named: "background-primary")

        return dataTable
    }

    func columnHeaders(type: StatementType) -> [String] {
        switch type {
        case .balanceSheet:
            return [""] + bst.map({NumDateFormatter.getQuarterString(date: $0.date, period: $0.period)})
        case .incomeStatement:
            return [""] + ist.map({NumDateFormatter.getQuarterString(date: $0.date, period: $0.period)})
        case .cashFlowStatement:
            return [""] + cfst.map({NumDateFormatter.getQuarterString(date: $0.date, period: $0.period)})
        }
    }

    func processSheet(type: StatementType, sheet: [[String]]) -> [[String]]{
        var finsheet = sheet
        
        switch type {
        case .balanceSheet:
            let columns = ["Date", "Cash & Cash Equivalents", "Short-Term Investments", "Net Receivables", "Inventory", "Current Assets", "Net PP&E", "Long-Term Investments", "Non-Current Assets", "Total Assets", "Accounts Payable", "Short-Term Debt", "Deferred Revenue", "Current Liabilities", "Long-Term Debt", "Non-Current Liabilities", "Total Liabilities", "Common Stock", "Retained Earnings", "Total Stockholder Equity", "Total Debt"]
            finsheet.insert(columns, at: 0)
        case .incomeStatement:
            let columns = ["Date", "Revenue", "Cost of Revenue", "Gross Profit", "Gross Profit Ratio", "R&D Expenses", "G&A Expenses", "S&M Expenses", "Operating Expenses", "Interest Expense", "Dep. & Amortization", "EBITDA", "EBITDA Ratio", "Operating Income", "Income Before Tax", "Income Tax Expense", "Net Income", "Net Income Ratio", "EPS", "EPS Diluted"]
            finsheet.insert(columns, at: 0)
        case .cashFlowStatement:
            let columns = ["Date", "Net Income", "Dep. & Amortization", "Deferred Income Tax", "Stock-Based Comp.", "Working Capital Change", "Accounts Receivables", "Accounts Payables", "Net Cash - Operating Activities", "PPE Investments", "Investment Purchases", "Investment Sales", "Net Cash - Investing", "Debt Repayment", "Common Stock Issued", "Common Stock Repurchased", "Dividends Paid", "Net Change - Cash", "Cash - End", "Cash - Beginning", "Operating Cash Flow", "Capital Expenditure", "Free Cash Flow"]
            finsheet.insert(columns, at: 0)
        }

        return finsheet
    }

    func data(type: StatementType) -> [[DataTableValueType]] {
        switch type {
        case .balanceSheet:
            let sheet = matrixTranspose(processSheet(type: .balanceSheet, sheet: bst.map({$0.rep})))
            return sheet.map { $0.compactMap (DataTableValueType.init) }
        case .incomeStatement:
            let sheet = matrixTranspose(processSheet(type: .incomeStatement, sheet: ist.map({$0.rep})))
            return sheet.map { $0.compactMap (DataTableValueType.init) }
        case .cashFlowStatement:
            let sheet = matrixTranspose(processSheet(type: .cashFlowStatement, sheet: cfst.map({$0.rep})))
            return sheet.map { $0.compactMap (DataTableValueType.init) }
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

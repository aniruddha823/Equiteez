//
//  FinancialStatements.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 12/3/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BalanceSheet: Codable {
    var date : String
    var period : String
    var cashAndCashEquivalents : Double
    var shortTermInvestments : Double
    var netReceivables : Double
    var inventory : Double
    var totalCurrentAssets : Double
    var propertyPlantEquipmentNet : Double
    var longTermInvestments : Double
    var totalNonCurrentAssets : Double
    var totalAssets : Double
    var accountPayables : Double
    var shortTermDebt : Double
    var deferredRevenue : Double
    var totalCurrentLiabilities : Double
    var longTermDebt : Double
    var totalNonCurrentLiabilities : Double
    var totalLiabilities : Double
    var commonStock : Double
    var retainedEarnings : Double
    var totalStockholdersEquity : Double
    var totalDebt : Double
    
    var rep : [String] {
        return [
            date, 
            NumDateFormatter.getFormattedNumberString(num: cashAndCashEquivalents),
            NumDateFormatter.getFormattedNumberString(num: shortTermInvestments),
            NumDateFormatter.getFormattedNumberString(num: netReceivables),
            NumDateFormatter.getFormattedNumberString(num: inventory),
            NumDateFormatter.getFormattedNumberString(num: totalCurrentAssets),
            NumDateFormatter.getFormattedNumberString(num: propertyPlantEquipmentNet),
            NumDateFormatter.getFormattedNumberString(num: longTermInvestments),
            NumDateFormatter.getFormattedNumberString(num: totalNonCurrentAssets),
            NumDateFormatter.getFormattedNumberString(num: totalAssets),
            NumDateFormatter.getFormattedNumberString(num: accountPayables),
            NumDateFormatter.getFormattedNumberString(num: shortTermDebt),
            NumDateFormatter.getFormattedNumberString(num: deferredRevenue),
            NumDateFormatter.getFormattedNumberString(num: totalCurrentLiabilities),
            NumDateFormatter.getFormattedNumberString(num: longTermDebt),
            NumDateFormatter.getFormattedNumberString(num: totalNonCurrentLiabilities),
            NumDateFormatter.getFormattedNumberString(num: totalLiabilities),
            NumDateFormatter.getFormattedNumberString(num: commonStock),
            NumDateFormatter.getFormattedNumberString(num: retainedEarnings),
            NumDateFormatter.getFormattedNumberString(num: totalStockholdersEquity),
            NumDateFormatter.getFormattedNumberString(num: totalDebt)
        ]
    }
}

struct IncomeStatement: Codable {
    var name: String
    var size: Int
    var population: Int
}

struct CashFlowStatement: Codable {
    var name: String
    var size: Int
    var population: Int
}

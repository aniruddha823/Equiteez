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
    var date : String
    var period : String
    var revenue : Double
    var costOfRevenue : Double
    var grossProfit : Double
    var grossProfitRatio : Double
    var researchAndDevelopmentExpenses : Double
    var generalAndAdministrativeExpenses : Double
    var sellingAndMarketingExpenses : Double
    var operatingExpenses : Double
    var interestExpense : Double
    var depreciationAndAmortization : Double
    var ebitda : Double
    var ebitdaratio : Double
    var operatingIncome : Double
    var incomeBeforeTax : Double
    var incomeTaxExpense : Double
    var netIncome : Double
    var netIncomeRatio : Double
    var eps : Double
    var epsdiluted : Double
    
    var rep : [String] {
        return [
            date,
            NumDateFormatter.getFormattedNumberString(num: revenue),
            NumDateFormatter.getFormattedNumberString(num: costOfRevenue),
            NumDateFormatter.getFormattedNumberString(num: grossProfit),
            NumDateFormatter.getFormattedNumberString(num: grossProfitRatio),
            NumDateFormatter.getFormattedNumberString(num: researchAndDevelopmentExpenses),
            NumDateFormatter.getFormattedNumberString(num: generalAndAdministrativeExpenses),
            NumDateFormatter.getFormattedNumberString(num: sellingAndMarketingExpenses),
            NumDateFormatter.getFormattedNumberString(num: operatingExpenses),
            NumDateFormatter.getFormattedNumberString(num: interestExpense),
            NumDateFormatter.getFormattedNumberString(num: depreciationAndAmortization),
            NumDateFormatter.getFormattedNumberString(num: ebitda),
            NumDateFormatter.getFormattedNumberString(num: ebitdaratio),
            NumDateFormatter.getFormattedNumberString(num: operatingIncome),
            NumDateFormatter.getFormattedNumberString(num: incomeBeforeTax),
            NumDateFormatter.getFormattedNumberString(num: incomeTaxExpense),
            NumDateFormatter.getFormattedNumberString(num: netIncome),
            NumDateFormatter.getFormattedNumberString(num: netIncomeRatio),
            NumDateFormatter.getFormattedNumberString(num: eps),
            NumDateFormatter.getFormattedNumberString(num: epsdiluted)
        ]
    }
}

struct CashFlowStatement: Codable {
    var date : String
    var period : String
    var netIncome : Double
    var depreciationAndAmortization : Double
    var deferredIncomeTax : Double
    var stockBasedCompensation : Double
    var changeInWorkingCapital : Double
    var accountsReceivables : Double
    var accountsPayables : Double
    var netCashProvidedByOperatingActivities : Double
    var investmentsInPropertyPlantAndEquipment : Double
    var purchasesOfInvestments : Double
    var salesMaturitiesOfInvestments: Double
    var netCashUsedForInvestingActivites: Double
    var debtRepayment : Double
    var commonStockIssued : Double
    var commonStockRepurchased : Double
    var dividendsPaid : Double
    var netChangeInCash : Double
    var cashAtEndOfPeriod : Double
    var cashAtBeginningOfPeriod : Double
    var operatingCashFlow : Double
    var capitalExpenditure : Double
    var freeCashFlow : Double
    
    var rep : [String] {
        return [
            date,
            NumDateFormatter.getFormattedNumberString(num: netIncome),
            NumDateFormatter.getFormattedNumberString(num: depreciationAndAmortization),
            NumDateFormatter.getFormattedNumberString(num: deferredIncomeTax),
            NumDateFormatter.getFormattedNumberString(num: stockBasedCompensation),
            NumDateFormatter.getFormattedNumberString(num: changeInWorkingCapital),
            NumDateFormatter.getFormattedNumberString(num: accountsReceivables),
            NumDateFormatter.getFormattedNumberString(num: accountsPayables),
            NumDateFormatter.getFormattedNumberString(num: netCashProvidedByOperatingActivities),
            NumDateFormatter.getFormattedNumberString(num: investmentsInPropertyPlantAndEquipment),
            NumDateFormatter.getFormattedNumberString(num: purchasesOfInvestments),
            NumDateFormatter.getFormattedNumberString(num: salesMaturitiesOfInvestments),
            NumDateFormatter.getFormattedNumberString(num: netCashUsedForInvestingActivites),
            NumDateFormatter.getFormattedNumberString(num: debtRepayment),
            NumDateFormatter.getFormattedNumberString(num: commonStockIssued),
            NumDateFormatter.getFormattedNumberString(num: commonStockRepurchased),
            NumDateFormatter.getFormattedNumberString(num: dividendsPaid),
            NumDateFormatter.getFormattedNumberString(num: netChangeInCash),
            NumDateFormatter.getFormattedNumberString(num: cashAtEndOfPeriod),
            NumDateFormatter.getFormattedNumberString(num: cashAtBeginningOfPeriod),
            NumDateFormatter.getFormattedNumberString(num: operatingCashFlow),
            NumDateFormatter.getFormattedNumberString(num: capitalExpenditure),
            NumDateFormatter.getFormattedNumberString(num: freeCashFlow)
        ]
    }
}

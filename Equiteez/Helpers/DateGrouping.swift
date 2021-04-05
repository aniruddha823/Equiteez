//
//  DateGrouping.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 3/14/21.
//  Copyright © 2021 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DayTransaction {
    var date: Date
    var shareList: [String: Int]
    var eodBalance: Double

    init(exactDate: Date, shares: [String: Int]) {
        self.date = exactDate
        self.shareList = shares
        self.eodBalance = -1
    }
}

class DateGrouping {
    var trades: [Trade]
    var transfers: [Transfer]
    var dailyTransactions: [DayTransaction]
    var fmt = DateFormatter()
    var dateStart: Date
    var tickerSet = Set<String>()
    
    init() throws {
        self.dailyTransactions = [DayTransaction]()
        self.dateStart = Date()
        
        do {
            trades = try PersistentService.context.fetch(Trade.getSortedFetchRequest())
            transfers = try PersistentService.context.fetch(Transfer.getSortedFetchRequest())
        } catch let error as NSError { throw error }
    }
    
    // Groups a list of trades by the ticker
    private func groupedTradesByTicker(transactions: [Trade]) -> [String: [Trade]] {
        let empty: [String: [Trade]] = [:]
      return transactions.reduce(into: empty) { acc, cur in
        var existing = acc[cur.ticker] ?? []
        existing.append(cur)
        acc[cur.ticker] = existing
      }
    }

    // Gets the net shares owned/last trade on each day for a ticker (e.g. reduces days
    // with multiple trades of a stock to the last trade made on that day)
    func groupedTradesByDay(transactions: [Trade]) -> [Date: Trade] {
        let empty: [Date: Trade] = [:]
      return transactions.reduce(into: empty) { acc, cur in
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: cur.dateAcquired))
        let date = Calendar.current.date(from: components)!
        var existing = acc[date] ?? cur

        if let lastTransactionOfDay = acc[date], lastTransactionOfDay.dateAcquired < cur.dateAcquired {
            existing = cur
            acc[date] = existing
        }
        else {
            existing = cur
            acc[date] = existing
        }
      }
    }

    // Groups a list of trades by the calendar day
    private func getDailyTransactions(tickertrades: [Trade]) {
        let groupedDays = groupedTradesByDay(transactions: tickertrades)
        let m = groupedDays.map { $0.value }.sorted { $0.dateAcquired < $1.dateAcquired }

        var i = 0
        var j = 0

        while i < dailyTransactions.count {
            if m.count == 1 {
                dailyTransactions[i].shareList[m[0].ticker] = Int(m[0].netShares)
                    i += 1
            } else if j == m.count - 1 {
                dailyTransactions[i].shareList[m[j].ticker] = Int(m[j].netShares)
                i += 1
            } else if m[j + 1].dateAcquired < dailyTransactions[i].date.timeIntervalSince1970 {
                    j += 1
            } else if m[j + 1].dateAcquired >= dailyTransactions[i].date.timeIntervalSince1970 {
                dailyTransactions[i].shareList[m[j].ticker] = Int(m[j].netShares)
                i += 1
            }
        }
    }

    // Creates a timeline with the number of shares owned on each day for
    // each ticker from the list of all trades
    func getTradeTimeline() -> [DayTransaction] {
        let groupedTickers = groupedTradesByTicker(transactions: trades.reversed() as Array)

        for ticker in groupedTickers.keys {
            tickerSet.insert(ticker)
            getDailyTransactions(tickertrades: groupedTickers[ticker]!)
        }

        return dailyTransactions.filter { !Calendar.current.isDateInWeekend($0.date) }
    }

    func getWalletTimeline() {
        fmt.dateFormat = "MM-dd-yyyy HH:mm:ss Z"
        fmt.timeZone = TimeZone(abbreviation: "PST")

        let sl2 = groupedTradesByDay(transactions: trades.reversed() as Array)

        let m = sl2.map { $0.value }.sorted { $0.dateAcquired < $1.dateAcquired }

        var i = 0
        var j = 0

        while i < dailyTransactions.count {
            if m.count == 1 {
                dailyTransactions[i].eodBalance = m[0].walletBalancePost
                i += 1
            } else if j == m.count - 1 {
                dailyTransactions[i].eodBalance = m[j].walletBalancePost
                i += 1
            } else if m[j + 1].dateAcquired < dailyTransactions[i].date.timeIntervalSince1970 {
                j += 1
            } else if m[j + 1].dateAcquired >= dailyTransactions[i].date.timeIntervalSince1970 {
                dailyTransactions[i].eodBalance = m[j].walletBalancePost
                i += 1
            }
        }
    }

    // Calculate the dates going back x days from today
    func getDateRange(daysBack: Int) {
        fmt.dateFormat = "MM-dd-yyyy HH:mm:ss Z"
        fmt.timeZone = TimeZone(abbreviation: "PST")
        var dstart = Calendar.current.date(byAdding: .day, value: 1, to: Date())!

        for i in 0..<daysBack {
            var dt = DayTransaction(exactDate: dstart, shares: [:])
            dailyTransactions.insert(dt, at: 0)
            dstart = Calendar.current.date(byAdding: .day, value: -1, to: dstart)!

            if i == daysBack - 1 {
                dt = DayTransaction(exactDate: dstart, shares: [:])
                dailyTransactions.insert(dt, at: 0)
            }
        }

        self.dateStart = dstart
    }

    // Calculate the net shares owned after each transaction made (running total)
    func getNetShares() {
        do {
            let fmt = DateFormatter()
            fmt.dateFormat = "MM-dd-yyyy HH:mm:ss Z"
            fmt.timeZone = TimeZone(abbreviation: "PST")
            let tradesByTicker = groupedTradesByTicker(transactions: trades.reversed() as Array)

            for i in tradesByTicker.keys {
                for j in 0..<tradesByTicker[i]!.count {

                    if j == 0 {
                        tradesByTicker[i]![j].netShares = tradesByTicker[i]![j].shareAmount
                    } else if tradesByTicker[i]![j].type == "Buy" {
                        tradesByTicker[i]![j].netShares = tradesByTicker[i]![j - 1].netShares + tradesByTicker[i]![j].shareAmount
                    } else if tradesByTicker[i]![j].type == "Sell" {
                        tradesByTicker[i]![j].netShares = tradesByTicker[i]![j - 1].netShares - tradesByTicker[i]![j].shareAmount
                    }
                }
            }

            for t in trades {
                print("ticker: \(t.ticker), type: \(t.type), shareamt: \(t.shareAmount), netshares: \(t.netShares), date: \(fmt.string(from: Date(timeIntervalSince1970: t.dateAcquired)))")
            }

            PersistentService.saveContext()
        } catch { print(error) }
    }

    // Reset net shares owned for each transaction to -1
    func resetNetShares() {
        do {
            for t in trades.reversed() as Array {
                t.netShares = -1

                print("ticker: \(t.ticker), type: \(t.type), shareamt: \(t.shareAmount), netshares: \(t.netShares), date: \(fmt.string(from: Date(timeIntervalSince1970: t.dateAcquired)))")
            }

            PersistentService.saveContext()
        } catch { print(error) }
    }

    // Get the remaining wallet balance after each transaction made
    func getPostTransactionBalances() {
        do {
            for i in 0..<transfers.count - 1 {
                trades[i].walletBalancePost = transfers[i].walletBalance
            }

            PersistentService.saveContext()
        } catch { print("fail") }
    }
}

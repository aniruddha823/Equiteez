import UIKit
//import Alamofire
//import SwiftyJSON

var str = "Hello, playground"

struct Transaction {
    var ticker: String
    var netShares: Int
    var shareAmount: Int
    var timestamp: Date
    var type: String

    init(ticker: String, shareAmount: Int, netShares: Int, timestamp: Double, type: String) {
        self.ticker = ticker
        self.shareAmount = shareAmount
        self.netShares = netShares
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        self.type = type
    }
}

class DayTransaction {
    var date: Date
    var shareList: [String: Int]

    init(exactDate: Date, shares: [String: Int]) {
        self.date = exactDate
        self.shareList = shares
    }
}

let sampleDates = ["02-28-2021 09:15" : 5, "03-01-2021 12:45" : 12, "03-03-2021 17:30" : 2, "03-05-2021 22:30" : 4, "03-06-2021 08:00" : 7, "03-06-2021 14:00" : 6]
let sampleDates2 = ["02-26-2021 09:00" : 1, "03-02-2021 12:45" : 10, "03-02-2021 16:30" : 6, "03-04-2021 23:45" : 8, "03-05-2021 07:45" : 5, "03-06-2021 14:00" : 12]
let sampleDates3 = [1614532500.0 : 5, 1614631500.0 : 12, 1614821400.0 : 2, 1615012200.0 : 4, 1615046400.0 : 7, 1615068000.0 : 6]
//let sampleDates4 = [Transaction(ticker: "AAPL", netShares: 5, timestamp: 1614532500.0),
//                    Transaction(ticker: "AAPL", netShares: 12, timestamp: 1614631500.0),
//                    Transaction(ticker: "AAPL", netShares: 2, timestamp: 1614821400.0),
//                    Transaction(ticker: "AAPL", netShares: 4, timestamp: 1615012200.0),
//                    Transaction(ticker: "AAPL", netShares: 7, timestamp: 1615046400.0),
//                    Transaction(ticker: "AAPL", netShares: 6, timestamp: 1615068000.0)]
//
//let sampleDates5 = [Transaction(ticker: "GS", netShares: 1, timestamp: 1614358800.0),
//                    Transaction(ticker: "GS", netShares: 10, timestamp: 1614717900.0),
//                    Transaction(ticker: "GS", netShares: 6, timestamp: 1614731400.0),
//                    Transaction(ticker: "GS", netShares: 8, timestamp: 1614930300.0),
//                    Transaction(ticker: "GS", netShares: 5, timestamp: 1614959100.0),
//                    Transaction(ticker: "GS", netShares: 12, timestamp: 1615068000.0)]
//
//let trades = [Transaction(ticker: "GS", netShares: 1, timestamp: 1614358800.0),
//                    Transaction(ticker: "AAPL", netShares: 5, timestamp: 1614532500.0),
//                    Transaction(ticker: "AAPL", netShares: 12, timestamp: 1614631500.0),
//                    Transaction(ticker: "GS", netShares: 10, timestamp: 1614717900.0),
//                    Transaction(ticker: "GS", netShares: 6, timestamp: 1614731400.0),
//                    Transaction(ticker: "AAPL", netShares: 2, timestamp: 1614821400.0),
//                    Transaction(ticker: "GS", netShares: 8, timestamp: 1614930300.0),
//                    Transaction(ticker: "GS", netShares: 5, timestamp: 1614959100.0),
//                    Transaction(ticker: "AAPL", netShares: 4, timestamp: 1615012200.0),
//                    Transaction(ticker: "AAPL", netShares: 7, timestamp: 1615046400.0),
//                    Transaction(ticker: "AAPL", netShares: 6, timestamp: 1615068000.0),
//                    Transaction(ticker: "GS", netShares: 12, timestamp: 1615068000.0)]

let trades2 = [Transaction(ticker: "GS", shareAmount: 1, netShares: -1, timestamp: 1614358800.0, type: "buy"),
              Transaction(ticker: "AAPL", shareAmount: 5, netShares: -1, timestamp: 1614532500.0, type: "buy"),
              Transaction(ticker: "AAPL", shareAmount: 7, netShares: -1, timestamp: 1614631500.0, type: "buy"),
              Transaction(ticker: "GS", shareAmount: 9, netShares: -1, timestamp: 1614717900.0, type: "buy"),
              Transaction(ticker: "GS", shareAmount: 4, netShares: -1, timestamp: 1614731400.0, type: "sell"),
              Transaction(ticker: "AAPL", shareAmount: 10, netShares: -1, timestamp: 1614821400.0, type: "sell"),
              Transaction(ticker: "GS", shareAmount: 2, netShares: -1, timestamp: 1614930300.0, type: "buy"),
              Transaction(ticker: "GS", shareAmount: 3, netShares: -1, timestamp: 1614959100.0, type: "sell"),
              Transaction(ticker: "AAPL", shareAmount: 2, netShares: -1, timestamp: 1615012200.0, type: "buy"),
              Transaction(ticker: "AAPL", shareAmount: 3, netShares: -1, timestamp: 1615046400.0, type: "buy"),
              Transaction(ticker: "AAPL", shareAmount: 1, netShares: -1, timestamp: 1615068000.0, type: "sell"),
              Transaction(ticker: "GS", shareAmount: 7, netShares: -1, timestamp: 1615068000.0, type: "buy")]

let trades3 = [Transaction(ticker: "GS", shareAmount: 1, netShares: -1, timestamp: 1614358800.0, type: "buy"),
Transaction(ticker: "AAPL", shareAmount: 5, netShares: -1, timestamp: 1614532500.0, type: "buy"),
Transaction(ticker: "AAPL", shareAmount: 7, netShares: -1, timestamp: 1614631500.0, type: "buy"),
Transaction(ticker: "GS", shareAmount: 9, netShares: -1, timestamp: 1614717900.0, type: "buy"),
Transaction(ticker: "GS", shareAmount: 4, netShares: -1, timestamp: 1614731400.0, type: "sell"),
Transaction(ticker: "AAPL", shareAmount: 10, netShares: -1, timestamp: 1614821400.0, type: "sell"),
Transaction(ticker: "GS", shareAmount: 2, netShares: -1, timestamp: 1614930300.0, type: "buy"),
Transaction(ticker: "GS", shareAmount: 3, netShares: -1, timestamp: 1614959100.0, type: "sell"),
Transaction(ticker: "GS", shareAmount: 7, netShares: -1, timestamp: 1615068000.0, type: "buy")]

var mydates : [String] = []
var mydates2 : [Date] = []
var dateFrom =  Date() // First date
var dateTo = Date()   // Last date

let format = DateFormatter()
format.dateFormat = "MM-dd-yyyy HH:mm"
format.timeZone = TimeZone(abbreviation: "PST")
//for d in sampleDates2.keys {
//    let dateobject = format.date(from: d)
//
//    print("date: \(format.string(from: dateobject!)), t: \(dateobject!.timeIntervalSince1970)")
//}

let fmt = DateFormatter()
fmt.dateFormat = "MM-dd-yyyy Z"
fmt.timeZone = TimeZone(abbreviation: "PST")
dateFrom = fmt.date(from: "02-28-2021 -0800")!
dateTo = fmt.date(from: "03-06-2021 -0800")!
var p = [DayTransaction]()
while dateFrom <= dateTo {
    var dt = DayTransaction(exactDate: dateFrom, shares: [:])
    p.append(dt)
    dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
}

func groupedTransactionsByDay(_ transactions: [Transaction]) -> [Date: Transaction] {
    let empty: [Date: Transaction] = [:]
  return transactions.reduce(into: empty) { acc, cur in
    let components = Calendar.current.dateComponents([.year, .month, .day], from: cur.timestamp)
    let date = Calendar.current.date(from: components)!
    var existing = acc[date] ?? cur

    if let lastTransactionOfDay = acc[date], lastTransactionOfDay.timestamp.timeIntervalSince1970 < cur.timestamp.timeIntervalSince1970 {
        existing = cur
        acc[date] = existing
    } else {
        existing = cur
        acc[date] = existing
    }
  }
}

func groupedTransactionsByTicker(_ transactions: [Transaction]) -> [String: [Transaction]] {
    let empty: [String: [Transaction]] = [:]
  return transactions.reduce(into: empty) { acc, cur in
    var existing = acc[cur.ticker] ?? []
    existing.append(cur)
    acc[cur.ticker] = existing
  }
}

func getDailyTransactions(tickertrades: [Transaction]) {
    let grouped = groupedTransactionsByDay(tickertrades)
    let m = grouped.map { $0.value }.sorted { $0.timestamp < $1.timestamp }

    var i = 0
    var j = 0

    while i < p.count {

        if i == p.count - 1 {
            p[i].shareList[m[j + 1].ticker] = m[j + 1].netShares
        } else if m[j + 1].timestamp < p[i + 1].date {
            j += 1
            p[i].shareList[m[j].ticker] = m[j].netShares
        } else {
            p[i].shareList[m[j].ticker] = m[j].netShares
        }

        i += 1
    }
}

//func getWeekChart(symbol: String, datefrom: String, dateto: String, completionHandler: @escaping ([Double], [Double], [String]) -> ()) {
//    guard let url = URL(string: baseURL + "historical-price-full/\(symbol)?from=\(datefrom)&to=\(dateto)&apikey=\(apikey)") else { return }
//
//    Alamofire.request(url, method: .get).validate().responseJSON { (response) in
//        guard response.result.isSuccess else { return }
//
//        let json = JSON(response.result.value)
//        var weekPrices = [Double]()
//        var weekPercentages = [Double]()
//        var weekDates = [String]()
//
//        // Should only loop once
//        for (_, day) in json["historical"] {
//            weekPrices.insert(day["vwap"].doubleValue, at: 0)
//            weekPercentages.insert(day["changePercent"].doubleValue, at: 0)
//            weekDates.insert(day["date"].stringValue, at: 0)
//        }
//
//        completionHandler(weekPrices, weekPercentages, weekDates)
//    }
//}
var groupedTickers = groupedTransactionsByTicker(trades3)

for i in groupedTickers.keys {
    for j in 0..<groupedTickers[i]!.count {

        if j == 0 {
            groupedTickers[i]![j].netShares = groupedTickers[i]![j].shareAmount
        } else if groupedTickers[i]![j].type == "buy" {
            groupedTickers[i]![j].netShares = groupedTickers[i]![j - 1].netShares + groupedTickers[i]![j].shareAmount
        } else if groupedTickers[i]![j].type == "sell" {
            groupedTickers[i]![j].netShares = groupedTickers[i]![j - 1].netShares - groupedTickers[i]![j].shareAmount
        }

        print("ticker: \(groupedTickers[i]![j].ticker), amount: \(groupedTickers[i]![j].shareAmount), net: \(groupedTickers[i]![j].netShares), type: \(groupedTickers[i]![j].type), date: \(format.string(from: groupedTickers[i]![j].timestamp))")
    }
}

let fmt2 = DateFormatter()
fmt2.dateFormat = "yyyy-MM-dd"

for ticker in groupedTickers.keys {
    getDailyTransactions(tickertrades: groupedTickers[ticker]!)
}

let timeline = p.filter { !Calendar.current.isDateInWeekend($0.date) }

for day in timeline {
    for ticker in day.shareList.keys {
        print("date: \(fmt.string(from: day.date)), ticker: \(ticker), netSharesEOD: \(day.shareList[ticker]!)")
    }
}






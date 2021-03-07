import UIKit

var str = "Hello, playground"

let sampleDates = ["02/28/2021 09:15" : 5, "03/01/2021 12:45" : 12, "03/03/2021 17:30" : 2, "03/05/2021 22:30" : 4, "03/06/2021 14:00" : 7]
let sampleDates2 = [1614532500.0 : 5, 1614631500.0 : 12, 1614821400.0 : 2, 1615012200.0 : 4, 1615068000.0 : 7]
var mydates : [String] = []
var dateFrom =  Date() // First date
var dateTo = Date()   // Last date

// Formatter for printing the date, adjust it according to your needs:
let fmt = DateFormatter()
fmt.dateFormat = "yyyy-MM-dd"
dateFrom = fmt.date(from: "2018-03-01")! // "2018-03-01"
dateTo = fmt.date(from: "2018-03-05")! // "2018-03-05"
while dateFrom <= dateTo {
    mydates.append(fmt.string(from: dateFrom))
    dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
}

let format = DateFormatter()
format.dateFormat = "MM-dd-yyyy HH:mm"
for d in sampleDates2.keys {
//    let dateobject = format.string(from: Date(timeIntervalSince1970: d))
    let dateobject = Date(timeIntervalSince1970: d)
    
    print(dateobject)
}





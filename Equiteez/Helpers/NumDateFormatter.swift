//
//  NumDateParser.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/11/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit

class NumDateFormatter {
    static let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    static var monthString = String()
    
    class func getFormattedNumberString(num: Double) -> String {
        
        var formatted = ""
        
        switch abs(num) / 1000.00 {
        case 1 ..< 1000:
            formatted = String(format: "%.2f", num / 1000.00) + "K"
        case 1000 ..< 1000000:
            formatted = String(format: "%.2f", num / 1000000.00) + "M"
        case 1000000 ..< 1000000000:
            formatted = String(format: "%.2f", num / 1000000000.00) + "B"
        case 1000000000 ..< 1000000000000:
            formatted = String(format: "%.2f", num / 1000000000000.00) + "T"
        default:
            formatted = "N/A"
        }
        
        return formatted
    }
    
    // converts date with string format YYYY-MM-DD into a format as such: July 4, 2018
    class func convertDate(dateString: String) -> String {
        let separated = dateString.split(separator: "-")

        if(Int(separated[1])! == 12) {
            monthString = months.last!
        } else { monthString = months[(Int(separated[1])! % 12) - 1] }
        let result = monthString + " " + separated[2] + ", " + separated[0]
        
        return result
    }
    
    //converts time string with format HH:MM:SS (24-hour) to HH:MM AM/PM (12-hour)
    class func getTimeString(timeString: String) -> String {
        let timedigits = timeString.split(separator: ":")
        var finalString = ""
        
        if let hour = Int(timedigits[0]), let minute = Int(timedigits[1]) {
            if (1...11 ~= hour) {
                finalString = "\(hour):\(minute) AM"
            } else if hour == 24 {
                finalString = "12:\(minute) AM"
            } else if (13...23 ~= hour) {
                finalString = "\(hour % 12):\(minute) PM"
            } else if hour == 12 {
                finalString = "12:\(minute) PM"
            }
        }
        
        return finalString
    }
    
    // converts date with format YYYYMMDD into a format as such: May 5, 2007
    class func convertDateIntraDay(dateNumbers: String) -> String {
        let monthInteger = dateNumbers.substring(fromIndex: 4, toIndex: 5)
        let dayInteger = dateNumbers.substring(fromIndex: 6, toIndex: 7)
        let yearInteger = dateNumbers.substring(fromIndex: 0, toIndex: 3)
        monthString = months[(Int(monthInteger!)! % 12 - 1)]
        let result =  monthString + " " + dayInteger! + ", " + yearInteger!
        
        return result
    }
    
    class func formatPercent(percentage: Double, label: UILabel) {
        if(percentage < 0) {
            label.text = String(format: "%.2f", percentage) + "%"
            label.backgroundColor = #colorLiteral(red: 0.8333047032, green: 0.1623813808, blue: 0.09398528188, alpha: 1)
        } else {
            label.text = "+" + String(format: "%.2f", percentage) + "%"
            label.backgroundColor = #colorLiteral(red: 0, green: 0.8085238338, blue: 0.4679548144, alpha: 1)
        }
    }
    
    class func getQuarterString(date: String, period: String) -> String {
        let dateComponents = date.split(separator: "-")
        return " \(period) \(dateComponents[0]) "
    }
}

extension String {
    func substring(fromIndex: Int, toIndex: Int) -> String? {
        if fromIndex < toIndex && toIndex < self.count /*use string.characters.count for swift3*/{
            let startIndex = self.index(self.startIndex, offsetBy: fromIndex)
            let endIndex = self.index(self.startIndex, offsetBy: toIndex)
            return String(self[startIndex...endIndex])
        } else{
            return nil
        }
    }
}

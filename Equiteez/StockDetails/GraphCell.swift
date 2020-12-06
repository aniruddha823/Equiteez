//
//  GraphCell.swift
//  Sample
//
//  Created by Aniruddha Prabhu on 6/21/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit
import Charts
import CoreData

class GraphCell: UICollectionViewCell, ChartViewDelegate {
    
    var symbol = ""
    var dates = [String]()
    var times = [String]()
    var percentages = [Double]()
    var prices = [Double]()
    var priceLabel = UILabel()
    var percentLabel = UILabel()
    var dateLabel = UILabel()
    
    @IBOutlet weak var priceGraph: LineChartView!
    
    @IBAction func getDayChart(_ sender: Any) {
        UserDefaults.standard.set("daily", forKey: "pricingType")
        FMPquery.getDayChart(symbol: symbol) { (dsp, dpc, dsd) in
            var lineChartEntries = [ChartDataEntry]()
            self.prices = dsp
            self.percentages = dpc
            self.dates = dsd
        
            for i in stride(from: 0, to: dsp.count, by: 1) {
                let day = ChartDataEntry(x: Double(i), y: dsp[i])
                lineChartEntries.append(day)
            }
        
            ViewAppearance.setupLineGraphView(lineChartView: self.priceGraph, lce: lineChartEntries)
        }
    }
    @IBAction func getWeekChart(_ sender: Any) {
        UserDefaults.standard.set("weekly", forKey: "pricingType")
        FMPquery.getWeekChart(symbol: symbol) { (wsp, wpc, wsd) in
            var lineChartEntries = [ChartDataEntry]()
            self.prices = wsp
            self.percentages = wpc
            self.dates = wsd
        
            for i in stride(from: 0, to: wsp.count, by: 1) {
                let day = ChartDataEntry(x: Double(i), y: wsp[i])
                lineChartEntries.append(day)
            }
        
            ViewAppearance.setupLineGraphView(lineChartView: self.priceGraph, lce: lineChartEntries)
        }
    }
    @IBAction func getMonthChart(_ sender: Any) {
        UserDefaults.standard.set("monthly", forKey: "pricingType")
        FMPquery.getMonthChart(symbol: symbol) { (msp, mpc, msd) in
            var lineChartEntries = [ChartDataEntry]()
            self.prices = msp
            self.percentages = mpc
            self.dates = msd
        
            for i in stride(from: 0, to: msp.count, by: 1) {
                let day = ChartDataEntry(x: Double(i), y: msp[i])
                lineChartEntries.append(day)
            }
        
            ViewAppearance.setupLineGraphView(lineChartView: self.priceGraph, lce: lineChartEntries)
        }
    }
    @IBAction func getYearChart(_ sender: Any) {
        UserDefaults.standard.set("yearly", forKey: "pricingType")
        FMPquery.getYearChart(symbol: symbol) { (ysp, ypc, ysd) in
            var lineChartEntries = [ChartDataEntry]()
            self.prices = ysp
            self.percentages = ypc
            self.dates = ysd
        
            for i in stride(from: 0, to: ysp.count, by: 1) {
                let day = ChartDataEntry(x: Double(i), y: ysp[i])
                lineChartEntries.append(day)
            }
        
            ViewAppearance.setupLineGraphView(lineChartView: self.priceGraph, lce: lineChartEntries)
        }
    }
    @IBAction func get2YearChart(_ sender: Any) {
        UserDefaults.standard.set("twoyear", forKey: "pricingType")
        FMPquery.getTwoYearChart(symbol: symbol) { (tysp, typc, tysd) in
            var lineChartEntries = [ChartDataEntry]()
            self.prices = tysp
            self.percentages = typc
            self.dates = tysd
        
            for i in stride(from: 0, to: tysp.count, by: 1) {
                let day = ChartDataEntry(x: Double(i), y: tysp[i])
                lineChartEntries.append(day)
            }
        
            ViewAppearance.setupLineGraphView(lineChartView: self.priceGraph, lce: lineChartEntries)
        }
    }
    
    func setupCell(ticker: String) {
        symbol = ticker
        priceGraph.delegate = self
        priceGraph.doubleTapToZoomEnabled = false
        priceGraph.pinchZoomEnabled = false
        
        UserDefaults.standard.set("monthly", forKey: "pricingType")
        FMPquery.getMonthChart(symbol: ticker) { (msp, mpc, msd) in
            var lineChartEntries = [ChartDataEntry]()
            self.prices = msp
            self.percentages = mpc
            self.dates = msd
        
            for i in stride(from: 0, to: msp.count, by: 1) {
                let day = ChartDataEntry(x: Double(i), y: msp[i])
                lineChartEntries.append(day)
            }
        
            ViewAppearance.setupLineGraphView(lineChartView: self.priceGraph, lce: lineChartEntries)
        }
    }
    
    // Change the price label to its respective value when scrolling
    // through the price graph
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let pricingType = UserDefaults.standard.string(forKey: "pricingType")
        if pricingType == "daily" {
            setupIntraDayLabels(number: Int(entry.x))
        } else {
            setupLineGraphLabels(number: Int(entry.x))
        }
    }

    // Reset price graph to the default value
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        let pricingType = UserDefaults.standard.string(forKey: "pricingType")
        if pricingType == "daily" {
            setupIntraDayLabels(number: dates.count - 1)
        } else {
            setupLineGraphLabels(number: dates.count - 1)
        }
    }

    // Setup the labels when scrolling through the price graph
    func setupLineGraphLabels(number: Int) {
        let dict: [String:String] = ["price": "$" + String(format: "%.2f", prices[number]),
                                     "percent": String(format: "%.2f", percentages[number]),
                                     "date": NumDateFormatter.convertDate(dateString: dates[number])]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLabels"), object: nil, userInfo: dict)
    }

    func setupIntraDayLabels(number: Int) {
        let splitted = dates[number].split(separator: " ")
        let date = NumDateFormatter.convertDate(dateString: String(splitted[0]))
        let time = NumDateFormatter.getTimeString(timeString: String(splitted[1]))
        
        let dict: [String:String] = [
            "price": "$" + String(format: "%.2f", prices[number]),
            "percent": String(format: "%.2f", percentages[number]),
            "date": "\(time) \(date)"]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLabels"), object: nil, userInfo: dict)
    }
}

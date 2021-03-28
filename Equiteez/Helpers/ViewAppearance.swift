//
//  ViewAppearance.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/10/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ViewAppearance {
    
    class func setupShadow(view: UIView) {
        view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
    }
    
    class func setColor(value: Double) -> UIColor {
        if(value < 0) { return UIColor.red }
        else { return UIColor.green }
    }
    
    class func setupLineGraphView(lineChartView: LineChartView, lce: [ChartDataEntry]) {
        let line = LineChartDataSet(entries: lce, label: "")
        line.drawValuesEnabled = false
        line.drawCirclesEnabled = false
        line.drawFilledEnabled = true
        line.fillAlpha = 1
        let gradientColors = [UIColor(red: 0/255.0, green: 200/255.0, blue: 100/255.0, alpha: 1).cgColor, UIColor(red: 0/255.0, green: 200/255.0, blue: 100/255.0, alpha: 1).cgColor, UIColor(red: 0/255.0, green: 200/255.0, blue: 100/255.0, alpha: 1).cgColor, UIColor.white.cgColor] as CFArray;
        let colorLocations : [CGFloat] = [0.0, 0.333, 0.666, 1.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        line.fill = Fill(linearGradient: gradient!, angle: 270)
        line.colors = [UIColor.clear]
        
        let data = LineChartData(dataSet: line)
        
        lineChartView.data = data
        lineChartView.xAxis.enabled = false
        lineChartView.minOffset = 0
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.drawBordersEnabled = false
        lineChartView.chartDescription?.text = ""
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    class func setupBarGraphView(barChartView: BarChartView) {
        barChartView.xAxis.enabled = false
        barChartView.minOffset = 0
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.chartDescription?.text = ""
        barChartView.drawBordersEnabled = false
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    class func setupCandleStickView(cscView: CandleStickChartView) {
        cscView.doubleTapToZoomEnabled = false
        cscView.pinchZoomEnabled = true
        cscView.chartDescription?.text = ""
        cscView.leftAxis.drawGridLinesEnabled = false
        cscView.rightAxis.drawGridLinesEnabled = false
        cscView.xAxis.enabled = false
        cscView.rightAxis.enabled = false
        cscView.drawBordersEnabled = false
        cscView.legend.enabled = false
    }
    
    class func makeBarGraph(values: [Double], labelText: String) -> BarChartView {
        var bgv = BarChartView()
        var entries = [BarChartDataEntry]()
        var barColors = [UIColor]()
        for i in stride(from: 0, to: values.count, by: 1){
            let entry = BarChartDataEntry(x: Double(i), y: Double(values[i]) / 1000000)
            entries.append(entry)
            
            if (values[i] < 0) {barColors.append(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))}
            else {barColors.append(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1))}
        }
        
        let cds = BarChartDataSet(entries: entries, label: labelText + " (millions $)")
        cds.colors = barColors
        let cd = BarChartData(dataSets: [cds])
        bgv.data = cd
        ViewAppearance.setupBarGraphView(barChartView: bgv)
        
        return bgv
    }
}

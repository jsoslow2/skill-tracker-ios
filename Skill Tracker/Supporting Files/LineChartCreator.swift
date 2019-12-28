//
//  LineChartCreator.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/27/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import Charts
import UIKit

struct LineChartCreator {
    static func createChart(lineChartView: LineChartView, data: ChartData, miniDate: Double){
        lineChartView.data = data
        
        lineChartView.backgroundColor = .white
        lineChartView.rightAxis.enabled = false
        
        
        let xAxis = lineChartView.xAxis
        xAxis.granularityEnabled = true
        xAxis.granularity = 1.0
        //        xAxis.granularity = 3600.0 * 24.0
                
        xAxis.spaceMin = xAxis.granularity / 5
        xAxis.spaceMax = xAxis.granularity / 5
                
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = false
                
        xAxis.drawGridLinesEnabled = false
                
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 5
        xAxis.valueFormatter = DateValueFormatter(miniTime : miniDate)
        
    }
}

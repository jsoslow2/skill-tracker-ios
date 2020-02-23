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
        xAxis.labelCount = 6
        xAxis.valueFormatter = DateValueFormatter(miniTime : miniDate)
        
    }
    
    static func doDataProcessingAndCreateChart (lineChartView: LineChartView ) {
        let lineChartData = LineChartData()
        let skillmanip = SkillManipulation.maxValueByDateBySkill(allLevelUps: CurrentUserData.allLevelUps)
        
        SkillManipulation.sumByDateBySkill(skillMax: skillmanip) { (allSkillCharts) in
            var i = 0
            for skill in CurrentUserData.skillsSorted!.reversed() {
                let values = allSkillCharts[skill]
                let lineChartDataSet = LineChartDataSet(values:  values, label: skill)
                lineChartDataSet.drawCirclesEnabled = false
                let color = Designs.colors[i]
               
                let gradientColors = [color.cgColor, color.withAlphaComponent(0.5).cgColor] as CFArray // Colors of the gradient
                let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors, locations: colorLocations) // Gradient Object
                lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
                
                if (CurrentUserData.skillsSorted!.count <= 2) {
                    i += 6
                } else if (CurrentUserData.skillsSorted!.count <= 3) {
                    i += 4
                    } else if (CurrentUserData.skillsSorted!.count <= 4) {
                    i += 3
                } else if  (CurrentUserData.skillsSorted!.count <= 6) {
                    i += 2
                } else {
                    i += 1
                }
                
                lineChartDataSet.setColor(NSUIColor(cgColor: color.cgColor))
                lineChartDataSet.fillAlpha = 1.0
                lineChartDataSet.drawFilledEnabled = true
                lineChartDataSet.drawValuesEnabled = false
                lineChartDataSet.mode = .horizontalBezier
                
                if skill == "Total Level" {
                    lineChartDataSet.lineWidth = 7.0
                    lineChartDataSet.setColor(NSUIColor(cgColor: Designs.darkBlack.cgColor))
                    lineChartDataSet.drawValuesEnabled = true
                }
                lineChartData.addDataSet(lineChartDataSet)
            }
        }
        
        LineChartCreator.createChart(lineChartView: lineChartView, data: lineChartData, miniDate: CurrentUserData.miniDate!)
        lineChartView.leftAxis.axisMinimum = 0
    }
}

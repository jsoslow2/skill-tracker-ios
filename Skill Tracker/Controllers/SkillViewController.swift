//
//  SkillViewController.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/27/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import Charts

class SkillViewController : UIViewController {
    var skillNameTransfered : String?
    var indexTransfered : Int?
    var dataCleaned : [ChartDataEntry] = []
    var values = [1,3,5,4,8,9,15]
    var levelUps : [String: Any]?
    var cleaned : [(key: String, value: Any)] = []
    var dates : [Date] = []
    var miniDate : Double?
    
    
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelUps = CurrentUserData.allSkills?[indexTransfered!].levelUps
        cleaned = (levelUps?.sorted(by: {$0.0 < $1.0}))!
        
        
        dates = cleaned.map { tuple in
            let unixTimestamp = Double(tuple.0)!
            
            if miniDate != nil {
            } else {
                self.miniDate = unixTimestamp
            }
            var theDate = Date(timeIntervalSince1970: unixTimestamp)
            print(theDate)
            return theDate
        }
        skill.text = skillNameTransfered ?? ""
        
        createChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createChart() {
        for i in 0..<cleaned.count {
            let dataEntry = ChartDataEntry(x: Double(cleaned[i].key)! - self.miniDate!, y: (cleaned[i].value as AnyObject).doubleValue)
          dataCleaned.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(values: dataCleaned, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        lineChartView.backgroundColor = .white
        lineChartView.rightAxis.enabled = false
        lineChartDataSet.drawCirclesEnabled = false
        
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
        xAxis.valueFormatter = DateValueFormatter(miniTime : miniDate!)
        
        print(DateValueFormatter(miniTime: miniDate!))
    }
}

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
        
        cleaned = CurrentUserData.allLevelUps[skillNameTransfered!]!
        
        
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
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.fillColor = .blue
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        lineChartDataSet.drawCircleHoleEnabled = false
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        LineChartCreator.createChart(lineChartView: lineChartView, data: lineChartData, miniDate: miniDate!)
    }
}

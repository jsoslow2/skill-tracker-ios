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
    var dataCleaned : [ChartDataEntry] = []
    var values = [1,3,5,4,8,9,15]
    
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skill.text = skillNameTransfered ?? ""
        
        createChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createChart() {
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
          dataCleaned.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(values: dataCleaned, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
}

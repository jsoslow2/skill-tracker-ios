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
    
    
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelUps = CurrentUserData.allSkills?[indexTransfered!].levelUps
        cleaned = (levelUps?.sorted(by: {$0.0 < $1.0}))!
        
        skill.text = skillNameTransfered ?? ""
        
        createChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createChart() {
        for i in 0..<cleaned.count {
            let dataEntry = ChartDataEntry(x: Double(cleaned[i].key)!, y: (cleaned[i].value as AnyObject).doubleValue)
          dataCleaned.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(values: dataCleaned, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
}

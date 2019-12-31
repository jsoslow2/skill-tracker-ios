//
//  HomePageViewController.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/1/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import Charts

class HomePageViewController: UIViewController {
    var skills : [Skill]?
    var dataRaw : [String: [ChartDataEntry]] = [:]
    var lineChartData = LineChartData()
    
    @IBOutlet weak var theButton: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        

        
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
        SkillService.getAllSkills(uid: CurrentUserData.uid!) { (allSkills) in
            self.skills = allSkills
            CurrentUserData.allSkills = allSkills
            self.tableView.reloadData()
            
            
             
            CurrentUserData.getLevelUps(skills: allSkills) { (levelUps) in
                /*
                for skill in levelUps {
                    let lineChartDataSet = LineChartDataSet(values: skill.value, label: skill.key)
                    lineChartDataSet.drawCirclesEnabled = false
                    lineChartDataSet.drawCirclesEnabled = false
                    lineChartDataSet.setColor(NSUIColor(cgColor: Designs.colors.randomElement()!.cgColor))
                    lineChartDataSet.mode = .cubicBezier
                    lineChartDataSet.drawValuesEnabled = false
                    self.lineChartData.addDataSet(lineChartDataSet)
                }
               */
                
                let data = SkillManipulation.maxByDateBySkill(allLevelUps: CurrentUserData.allLevelUps)
                
                
                SkillManipulation.sumByDate(dates: data) { (data) in
                    let lineChartDataSet = LineChartDataSet(values: data, label: "Total Level")
                    lineChartDataSet.drawCirclesEnabled = false
                    lineChartDataSet.lineWidth = 5.0
                    
                    let color = Designs.colors.randomElement()!.cgColor
                    let color2 = Designs.colors.randomElement()!.cgColor
                    let gradientColors = [color, color2] as CFArray // Colors of the gradient
                    let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
                    let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
                    lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
                    lineChartDataSet.fillAlpha = 1.0
                    lineChartDataSet.setColor(NSUIColor(cgColor: color))
                    lineChartDataSet.mode = .cubicBezier
                    lineChartDataSet.drawFilledEnabled = true
                    self.lineChartData.addDataSet(lineChartDataSet)
                    
                    let skillmanip = SkillManipulation.maxValueByDateBySkill(allLevelUps: CurrentUserData.allLevelUps)
                    
                        SkillManipulation.sumByDateBySkill(skillMax: skillmanip) { (allSkillCharts) in
                            for skill in allSkillCharts {
                                let lineChartDataSet = LineChartDataSet(values: skill.value, label: skill.key)
                                lineChartDataSet.drawCirclesEnabled = false
                                lineChartDataSet.drawCirclesEnabled = false
                                lineChartDataSet.setColor(NSUIColor(cgColor: Designs.colors.randomElement()!.cgColor))
                                lineChartDataSet.mode = .cubicBezier
                                lineChartDataSet.drawValuesEnabled = false
                                self.lineChartData.addDataSet(lineChartDataSet)
                            }
                        }
                    
                    LineChartCreator.createChart(lineChartView: self.lineChartView, data: self.lineChartData, miniDate: CurrentUserData.miniDate!)
                    
                    self.lineChartView.animate(yAxisDuration: 2.0)
                    self.lineChartView.largeContentTitle = "Total Level"
                    
                }
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        SkillService.levelUpSkill(uid: CurrentUserData.uid ?? "", skillName: "Fitness", currentLevel: 50, growthRate: 0.01) { (newLevel) in
            print(newLevel)
        }

        print("level up")
    }
    
    @IBAction func newSkill(_ sender: Any) {    }
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue) {
        DispatchQueue.main.async {
            SkillService.getAllSkills(uid: CurrentUserData.uid!) { (allSkills) in
                self.skills = allSkills
                CurrentUserData.allSkills = allSkills
                self.tableView.reloadData()
                
                
                CurrentUserData.getLevelUps(skills: allSkills) { (levelUps) in
                    for skill in levelUps {
                        let lineChartDataSet = LineChartDataSet(values: skill.value, label: skill.key)
                        lineChartDataSet.drawCirclesEnabled = false
                        lineChartDataSet.fillColor = NSUIColor(cgColor: Designs.colors.randomElement()!.cgColor)
                        lineChartDataSet.drawFilledEnabled = true
                        
                        self.lineChartData.addDataSet(lineChartDataSet)
                    }
                    LineChartCreator.createChart(lineChartView: self.lineChartView, data: self.lineChartData, miniDate: CurrentUserData.miniDate!)
                }
            }
        }
    }
    
}

extension HomePageViewController: UITableViewDataSource, skillCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let skills = skills {
            return skills.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell")! as! skillCell
        cell.delegate = self
        
        guard let skills = skills else {return cell}
        
        let skill = skills[indexPath.row]

        cell.indexNumber = indexPath.row
        
        cell.skillName = skill.skillName
        cell.growthRate = skill.growthRate
        cell.currentLevel = skill.currentLevel
        
        cell.title.text = skill.skillName
        cell.level.text = String(Int(skill.currentLevel)) + "/100"
        cell.progressView.progress = Float(cell.currentLevel! / 100.0)
    
        return cell
    }
    
    func goToSkill(on cell: skillCell) {
        let mainStoryboard = UIStoryboard(name: "SkillStoryBoard", bundle: nil)
        
        guard let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: "SkillViewController") as? SkillViewController else {
            print("no VC found"); return}
        
        destinationVC.skillNameTransfered = cell.skillName
        destinationVC.indexTransfered = cell.indexNumber 
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func levelUp(on cell: skillCell) {
        SkillService.levelUpSkill(uid: CurrentUserData.uid!, skillName: cell.skillName!, currentLevel: cell.currentLevel!, growthRate: cell.growthRate!) { (newLevel) in
            
            CurrentUserData.allSkills![cell.indexNumber!].currentLevel = newLevel
            self.skills = CurrentUserData.allSkills
            
            self.tableView.reloadData()
        }
        
        
        print("Leveled Up!")
    }
    
}

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
        print(CurrentUserData.email)
        print("im here")
        
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
        SkillService.getAllSkills(uid: CurrentUserData.uid!) { (allSkills) in
            self.skills = allSkills
            CurrentUserData.allSkills = allSkills
            self.tableView.reloadData()
            
            
            CurrentUserData.getLevelUps(skills: allSkills) { (levelUps) in
                for skill in levelUps {
                    let lineChartDataSet = LineChartDataSet(values: skill.value, label: skill.key)
                    lineChartDataSet.drawCirclesEnabled = false
                    self.lineChartData.addDataSet(lineChartDataSet)
                }
                LineChartCreator.createChart(lineChartView: self.lineChartView, data: self.lineChartData, miniDate: CurrentUserData.miniDate!)
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
        cell.level.text = String(skill.currentLevel)
    
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

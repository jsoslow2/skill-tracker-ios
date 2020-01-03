//
//  CompleteCreateASkillViewController.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/28/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

class CompleteCreateASkillViewController : UIViewController {
    var passedSkillName : String?
    
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillSliderView: UISlider!
    @IBOutlet weak var skillLevel: UILabel!
    @IBOutlet weak var growthSlider: UISlider!
    @IBOutlet weak var growthRate: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillName.text = passedSkillName
        skillLevel.text = String(Int(skillSliderView.value))
        growthRate.text = String(Int(growthSlider.value) / 100) + "%"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func skillSliderChange(_ sender: Any) {
        skillLevel.text = "Level " + String(Int(skillSliderView.value))
    }
    @IBAction func growthSliderChange(_ sender: Any) {
        growthRate.text = String(Int(growthSlider.value)) + " %"
    }
    
    @IBAction func completeCreateASkill(_ sender: Any) {
        
        
        //Create Skill in server
        SkillService.createSkill(uid: CurrentUserData.uid!, skillName: passedSkillName!, currentLevel: Int(skillSliderView.value), growthRate: Double(round(growthSlider.value) / 100))
        
    }
}

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
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var skillSliderView: UISlider!
    @IBOutlet weak var skillLevel: UILabel!
    @IBOutlet weak var growthSlider: UISlider!
    @IBOutlet weak var growthRate: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var skillTitle: UILabel!
    @IBOutlet weak var growthRateTitle: UILabel!
    @IBOutlet weak var growthRateSubtitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
                
        mainTitle.font = UIFont(name: "Menlo-Bold", size: 25.0)
        mainTitle.text = "Current Skill Level?"
        
        skillTitle.font = UIFont(name: "Menlo", size: 15)
        skillTitle.text = "Level 0 = New Skill. Level 100 = Best in the World. Most people start skills between Level 0 and Level 30"
        skillTitle.textColor = .systemGray
        
        skillLevel.text = "Level " + String(Int(skillSliderView.value))
        skillLevel.font = UIFont(name: "Menlo", size: 15.0)
        
        completeButton.backgroundColor = Designs.mainColor
        completeButton.layer.cornerRadius = 10
        completeButton.addShadowView()
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.setTitle("Create Skill", for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func skillSliderChange(_ sender: Any) {
        skillLevel.text = "Level " + String(Int(skillSliderView.value))
    }

    
    @IBAction func completeCreateASkill(_ sender: Any) {
        
        
        //Create Skill in server
        SkillService.createSkill(uid: CurrentUserData.uid, skillName: passedSkillName!, currentLevel: Int(skillSliderView.value), growthRate: 0.01)
        
    }
}

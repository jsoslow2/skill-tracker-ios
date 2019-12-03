//
//  HomePageViewController.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/1/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

class HomePageViewController: UIViewController {
    @IBOutlet weak var theButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CurrentUserData.email)
        print("im here")
        
        SkillService.getAllSkills(uid: CurrentUserData.uid!) { (skills) in
            dump(skills)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        SkillService.levelUpSkill(uid: CurrentUserData.uid ?? "", skillName: "pooping", currentLevel: 50, growthRate: 0.01)
        print("button works")
    }
    
    @IBAction func newSkill(_ sender: Any) {
        SkillService.createSkill(uid: CurrentUserData.uid ?? "", skillName: "Social Skills", currentLevel: 30, growthRate: 0.01)
        print("new skill incoming")
    }
}

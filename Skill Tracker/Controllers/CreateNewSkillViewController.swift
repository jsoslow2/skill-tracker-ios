//
//  CreateNewSkillViewController.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/25/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

class CreateNewSkillViewController : UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var skillTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CompleteCreateASkillViewController
        
        destinationVC.passedSkillName = skillTextField.text
    }
    
    @IBAction func goToNextVC(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCompleteCreateASkill", sender: self)
    }
    
}

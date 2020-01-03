//
//  CreateNewSkillViewController.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/25/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class CreateNewSkillViewController : UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var skillTextField: UITextField!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        Designs.formatLabel(label: subTitle, size: 15, doColor: false)
        subTitle.text = "Pick a skill you want to improve over time. Some examples of great skills include 'Fitness', 'Meditation', or 'Python'"
        subTitle.textColor = .systemGray
        
        mainTitle.font = UIFont(name: "Menlo-Bold", size: 25)
        
        skillTextField.font = UIFont(name: "Menlo", size: 25)
        skillTextField.borderStyle = .roundedRect
        
        continueButton.titleLabel?.font = UIFont(name: "Menlo", size: 15)
        continueButton.backgroundColor = Designs.mainColor
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.addShadowView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CompleteCreateASkillViewController
        
        destinationVC.passedSkillName = skillTextField.text
    }
    
    func checkText () -> Bool {
        
        if skillTextField.text == "" {
            SCLAlertView().showTitle("Input a name for the skill", subTitle: "", timeout:.none, completeText: nil, style: .warning, colorStyle: UInt(bitPattern: 16765243), colorTextButton: UInt(bitPattern: 855309), circleIconImage: nil, animationStyle: .bottomToTop)
            return false
        } else {
            return true
        }
        
    }
    
    @IBAction func goToNextVC(_ sender: Any) {
        if checkText() {
          self.performSegue(withIdentifier: "goToCompleteCreateASkill", sender: self)
        }
    }
    
}

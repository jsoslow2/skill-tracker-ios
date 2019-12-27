//
//  skillCell.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/25/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

protocol skillCellDelegate: class {
    func levelUp(on cell: skillCell)
    func goToSkill(on cell: skillCell)
}

class skillCell : UITableViewCell {
    var skillName : String?
    var currentLevel : Double?
    var growthRate : Double?
    var indexNumber : Int?
    
    
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var levelUpButton: UIButton!
    
    var delegate: skillCellDelegate?
    
    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(skillCell.goToSkill(sender:)))
        addGestureRecognizer(tapGesture)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func levelUp(_ sender: Any) {
        delegate?.levelUp(on: self)
    }
    
    @objc func goToSkill (sender: UITapGestureRecognizer) {
        delegate?.goToSkill(on: self)
    }
}

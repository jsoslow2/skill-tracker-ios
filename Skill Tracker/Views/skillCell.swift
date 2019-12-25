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
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func levelUp(_ sender: Any) {
        delegate?.levelUp(on: self)
    }
}

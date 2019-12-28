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
    
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var levelUpButton: UIButton!
    
    var delegate: skillCellDelegate?
    
    override func awakeFromNib() {
        Designs.formatLabel(label: title, size: 20)
        Designs.formatLabel(label: level, size: 15)
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)

        
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
                let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.backgroundColor = Designs.lightBlue.cgColor
    }
}

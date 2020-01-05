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
    @IBOutlet weak var lowerLevel: UILabel!
    @IBOutlet weak var upperLevel: UILabel!
    
    var delegate: skillCellDelegate?
    
    override func awakeFromNib() {
        Designs.formatLabel(label: title, size: 14, doColor: true)
        Designs.formatLabel(label: level, size: 12)
        Designs.formatLabel(label: lowerLevel, size: 8)
        Designs.formatLabel(label: upperLevel, size: 8)
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)
        progressView.progressTintColor = Designs.blue4
        
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        levelUpButton.addShadowView()

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(skillCell.goToSkill(sender:)))
        addGestureRecognizer(tapGesture)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func levelUp(_ sender: Any) {
        delegate?.levelUp(on: self)
        UIView.animate(withDuration: 0.3,
        animations: {
            self.levelUpButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.levelUpButton.transform = CGAffineTransform.identity
            }
        })
    }
    
    @objc func goToSkill (sender: UITapGestureRecognizer) {
        delegate?.goToSkill(on: self)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
                let margins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.backgroundColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.addShadowView()
    }
}

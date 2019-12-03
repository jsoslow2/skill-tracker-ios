//
//  Skill.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/2/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot


class Skill {
    
    var skillName : String
    var currentLevel : Double
    var growthRate : Double
    var levelUps : [String: Any]
    
    init(skillName: String, currentLevel : Double, growthRate: Double, levelUps: [String: Any]) {
        self.skillName = skillName
        self.currentLevel = currentLevel
        self.growthRate = growthRate
        self.levelUps = levelUps
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let skillName = snapshot.key as? String,
            let currentLevel = dict["currentLevel"] as? Double,
            let growthRate = dict["growthRate"] as? Double,
            let levelUps = dict["levelUps"] as? [String: Any]
            else { return nil }

        self.skillName = skillName
        self.currentLevel = currentLevel
        self.growthRate = growthRate
        self.levelUps = levelUps
    }
    
}

//
//  CurrentUserData.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/1/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import Firebase

struct CurrentUserData {
    static var email : String?
    static var firstName : String?
    static var lastName : String?
    static var profilePic : String?
    static var uid : String?
    static var miniDate : Double?
    
    static var allSkills : [Skill]?
    static var allLevelUps : [String : [(key: String, value: Any)]] = [:]
    
    static func getLevelUps (skills: [Skill], completion: @escaping ([String : [(key: String, value: Any)]]) -> Void) {
        
        for skill in skills {
            let skillName = skill.skillName
            let levelUps = skill.levelUps
            
            let cleaned : [(key: String, value: Any)] = (levelUps.sorted(by: {$0.0 < $1.0}))
            
            cleaned.map { tuple in
                let unixTimestamp = Double(tuple.0)!
                
                if miniDate != nil {
                } else {
                    self.miniDate = unixTimestamp
                }
                
                if self.miniDate! > unixTimestamp {
                    self.miniDate = unixTimestamp
                }
            }
            print(cleaned)
            print(skillName)
            allLevelUps[skillName] = cleaned
        }
        
        completion(allLevelUps ?? [:])
    }
}

//
//  CurrentUserData.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/1/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import Firebase
import Charts

struct CurrentUserData {
    static var email : String?
    static var firstName : String?
    static var lastName : String?
    static var profilePic : String?
    static var uid : String?
    static var miniDate : Double?
    
    static var allSkills : [Skill]?
    static var allLevelUps : [String : [(key: String, value: Any)]] = [:]
    static var allLevelUpsCharts : [String : [ChartDataEntry]] = [:]
    
    static func getLevelUps (skills: [Skill], completion: @escaping ([String : [ChartDataEntry]]) -> Void) {
        
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
                
                var dataCleaned : [ChartDataEntry] = []
                for i in 0..<cleaned.count {
                    let dataEntry = ChartDataEntry(x: Double(cleaned[i].key)! - self.miniDate!, y: (cleaned[i].value as AnyObject).doubleValue)
                  dataCleaned.append(dataEntry)
                }
                
                allLevelUpsCharts[skillName] = dataCleaned
            }

            allLevelUps[skillName] = cleaned
        }
        
        completion(allLevelUpsCharts)
    }
}

//
//  SkillService.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/2/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct SkillService {
    
    static func createSkill(uid : String, skillName : String, currentLevel : Int, growthRate : Double) {
        let ref = Database.database().reference().child("Users").child(uid).child("Skills").child(skillName)
        var timestamp = NSDate().timeIntervalSince1970
        let timestampString = String(timestamp)
        let timestampFinal = timestampString.components(separatedBy: ".").first

        
        var dict = [String: Any]()
        var improvements = [String: Any]()
        
        dict["currentLevel"] = currentLevel
        dict["growthRate"] = growthRate
        dict["originalLevel"] = currentLevel
        
        improvements[timestampFinal!] = currentLevel
        
        dict["levelUps"] = improvements
        
        ref.updateChildValues(dict)
    }
    
    static func levelUpSkill(uid: String, skillName: String, currentLevel: Double, growthRate: Double) {
        let ref = Database.database().reference().child("Users").child(uid).child("Skills").child(skillName)
        let timestamp = NSDate().timeIntervalSince1970
        let timestampString = String(timestamp)
        let timestampFinal = timestampString.components(separatedBy: ".").first
        let newLevel = (100-currentLevel) * growthRate + currentLevel
        
        ref.child("currentLevel").setValue(newLevel)
        
        ref.child("levelUps").child(timestampFinal!).setValue(newLevel)
    }
    
    static func getAllSkills(uid: String, completion: @escaping([Skill]) -> Void) {
        let ref = Database.database().reference().child("Users").child(uid).child("Skills")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {completion([]); return}
            
            
            var skills = [Skill]()
            for snap in snapshot {
                let skill = Skill(snapshot: snap)
                
                skills.append(skill!)
            }
            
            completion(skills)
        }
    }
}

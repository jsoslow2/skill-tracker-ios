//
//  UserService.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/1/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct UserService {
    
    static func createUser ( completion: @escaping(Bool) -> Void) {
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
            FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) -> Void in
                
                if error != nil {
                    print(error)
                    completion(false)
                }
                
                let newResult = result as! [String: Any]
                
                if let email = newResult["email"] as? String,
                    let firstName = newResult["first_name"] as? String,
                    let lastName = newResult["last_name"] as? String,
                    let id = newResult["id"] as? String,
                    let picture = newResult["picture"] as? NSDictionary,
                    let data = picture["data"] as? NSDictionary,
                    let url = data["url"] as? String{
                    
                    let uid = Auth.auth().currentUser!.uid as String

                    let ref = Database.database().reference().child("Users").child(uid)
                    var updatedData = [String: Any]()
                    updatedData["email"] = email
                    updatedData["firstName"] = firstName
                    updatedData["lastName"] = lastName
                    updatedData["profilePic"] = url
                    ref.updateChildValues(updatedData)
                    
                    CurrentUserData.email = email
                    CurrentUserData.firstName = firstName
                    CurrentUserData.lastName = lastName
                    CurrentUserData.profilePic = url
                    
                    completion(true)
                }
            }
    }
    
    
    static func getCurrentUserData (completion: @escaping(String, String, String, String) -> Void) {
        let uid = Auth.auth().currentUser!.uid as String
        CurrentUserData.uid = uid
        let ref = Database.database().reference().child("Users").child(uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any],
            let email = dict["email"] as? String,
            let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String,
            let profilePic = dict["profilePic"] as? String
                else {completion("", "", "", ""); return}
            
            completion(email, firstName, lastName, profilePic)
        }
    }
        

    
}

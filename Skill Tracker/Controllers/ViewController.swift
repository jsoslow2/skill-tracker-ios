//
//  ViewController.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/1/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    

    let loginButton : FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
                
        if FBSDKAccessToken.currentAccessTokenIsActive() {
            UserService.getCurrentUserData { (email, firstName, lastName, profilePic) in
                CurrentUserData.email = email
                CurrentUserData.firstName = firstName
                CurrentUserData.lastName = lastName
                CurrentUserData.profilePic = profilePic
                self.goToHome()
            }
        }
        
    }
    
    func goToHome () {
        let mainStoryboard = UIStoryboard(name: "HomePageStoryboard", bundle: nil)
        let vc = (mainStoryboard.instantiateViewController(identifier: "HomePageViewController") as? HomePageViewController)!
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            print("no worky")
            return
          }
          print("Log in successful")
          UserService.createUser { (Bool) in
              self.goToHome()
          }
            
        }
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

}


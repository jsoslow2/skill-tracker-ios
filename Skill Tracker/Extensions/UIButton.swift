//
//  UIButton.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 1/1/20.
//  Copyright © 2020 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func pulsate () {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
}

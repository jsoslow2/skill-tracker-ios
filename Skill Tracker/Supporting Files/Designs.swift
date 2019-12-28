//
//  Designs.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/28/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit
import Charts

struct Designs {
    static let lightBlue = hexStringToUIColor(hex: "#A7C8F2")
    static let midBlue = hexStringToUIColor(hex: "#048ABF")
    static let darkTurquoise = hexStringToUIColor(hex: "#027368")
    static let orangeContrast = hexStringToUIColor(hex: "#F25116")
    static let darkBlack = hexStringToUIColor(hex: "#0D0D0D")
    
    
    static func formatLabel(label: UILabel, size: Int) {
        label.font = UIFont(name: "Avenir", size: CGFloat(size))
    }
    
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

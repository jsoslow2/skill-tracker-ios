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
    static let blue1 = hexStringToUIColor(hex: "#DCECC9")
    static let blue2 = hexStringToUIColor(hex: "#B3DDCC")
    static let blue3 = hexStringToUIColor(hex: "#8BCDCE")
    static let blue4 = hexStringToUIColor(hex: "#63BED3")
    static let blue5 = hexStringToUIColor(hex: "#46ABCE")
    static let blue6 = hexStringToUIColor(hex: "#3D91BE")
    static let blue7 = hexStringToUIColor(hex: "#3577AF")
    static let blue8 = hexStringToUIColor(hex: "#2D5F9F")
    static let blue9 = hexStringToUIColor(hex: "#24448E")
    static let blue10 = hexStringToUIColor(hex: "#1D2B7F")
    static let blue11 = hexStringToUIColor(hex: "#162065")
    static let blue12 = hexStringToUIColor(hex: "#162065")
    static let darkBlack = hexStringToUIColor(hex: "#0D0D0D")
    static let colors = [blue1, blue2, blue3, blue4, blue5, blue6, blue7, blue8, blue9, blue10, blue11, blue12, darkBlack]
    
    
    static func formatLabel(label: UILabel, size: Int) {
        label.font = UIFont(name: "Menlo", size: CGFloat(size))
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

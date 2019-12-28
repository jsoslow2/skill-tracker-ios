//
//  DateValueFormatter.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/27/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import Charts

open class DateValueFormatter : NSObject, IAxisValueFormatter
{
    var dateFormatter : DateFormatter
    var miniTime :Double
    
    public init(miniTime: Double) {
        //super.init()
        self.miniTime = miniTime
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "MM/dd HH:mm"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        let date2 = Date(timeIntervalSince1970 : (value) + miniTime)
        print(date2)
        return dateFormatter.string(from: date2)
    }
}

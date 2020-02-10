//
//  DateFunctions.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/30/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation

struct DateFunctions {
    static func stringToTimestamp (date: String, dateFormatter: DateFormatter) -> Double {
        let newValue = dateFormatter.date(from: date)
        return Double(newValue!.timeIntervalSince1970)
    }
    
    static func timestampToString (timestamp : Double, dateFormatter: DateFormatter) -> String {
            let newValue = Date(timeIntervalSince1970: timestamp)
        return dateFormatter.string(from: newValue)
    }
    
    static func getDateSequence(miniDate: Double, currentDate: NSDate) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = Date(timeIntervalSince1970: miniDate)
        var date = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
        var results : [String] = [dateFormatter.string(from: date)]
        let currentDateLessOne = Calendar.current.date(byAdding: .day, value: -1, to: currentDate as Date)!
        
        while date <= currentDateLessOne {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            results.append(dateFormatter.string(from: date))
        }
        print(results)
        return results
    }
}

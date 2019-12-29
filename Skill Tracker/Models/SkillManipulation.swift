//
//  SkillManipulation.swift
//  Skill Tracker
//
//  Created by Jack Soslow on 12/28/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import Charts
import UIKit

struct SkillManipulation {
    
    static func maxByDateBySkill (allLevelUps : [String : [(key: String, value: Any)]]) -> [(String, Double)] {
        var max : [Double] = []
        var dateStrings : [String] = []
        for i in allLevelUps {
            var array = i.value
            
            for i in 0..<array.count {
                let timestamp = array[i].0
                
                let date = Date(timeIntervalSince1970: Double(timestamp)!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let strDate = dateFormatter.string(from: date)
                
                array[i].0 = strDate
            }
            
            let dictionary = Dictionary(grouping: array, by: { $0.key })
            for i in dictionary {
                let tuples = i.value
                let values = tuples.map { Double(($0.value as AnyObject).doubleValue)}
                max.append(values.max()!)
            }
            
            dateStrings.append(contentsOf: Array(dictionary.keys))
                    }
        
        let results = zip(dateStrings, max).map { ($0, $1) }
        
        return results
    }
    
    static func sumByDate(dates : [(String, Double)], completion: @escaping([ChartDataEntry]) -> Void) {
        var results : [(timestamp: Double, value: Double)] = []
        let keys = Set<String>(dates.map{($0.0)})
        var timestamps : [Double] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for key in keys {
            let sum = dates.filter({$0.0 == key}).map({$0.1}).reduce(0, +)
            let date = dateFormatter.date(from: key)
            let timeStamp = (date?.timeIntervalSince1970)!
            
            timestamps.append(Double(timeStamp))
            results.append((Double(timeStamp), sum))
        }
        
        CurrentUserData.miniDate = timestamps.min()
        
        results = results.sorted(by: {$0.0 < $1.0})
        var dataCleaned : [ChartDataEntry] = []
        for i in 0..<results.count {
            let dataEntry = ChartDataEntry(x: Double(results[i].timestamp) - CurrentUserData.miniDate!, y: (results[i].value as AnyObject).doubleValue)
          dataCleaned.append(dataEntry)
        }
        
        completion(dataCleaned)
    }
}

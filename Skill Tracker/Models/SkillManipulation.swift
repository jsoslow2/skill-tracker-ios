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
    
    static func maxValueByDateBySkill (allLevelUps : [String : [(key: String, value: Any)]]) -> [String : [(date: String, max: Double)]] {
        var completion : [String : [(date: String, max: Double)]] = [:]
        
        for i in allLevelUps {
            let array = i.value
            var dates : [(String, Double)] = []
            var results : [(String, Double)] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let rawDates = array.map {dateFormatter.string(from: Date(timeIntervalSince1970: Double($0.0)!))}
            let values = array.map {Double(($0.1 as AnyObject).doubleValue)}
            
            dates = zip(rawDates, values).map { ($0, $1) }

            let keys = Set<String>(dates.map{($0.0)})
            for key in keys {
                let max = dates.filter({$0.0 == key}).map({$0.1}).max()
                
                results.append((String(key), max!))
            }
            let skillName = String(i.key)
            completion[skillName] = results

        }
        return completion
    }
    
    static func sumByDateBySkill (skillMax: [String : [(date: String, max: Double)]], completion: @escaping ([String : [ChartDataEntry]]) -> Void) {
        var skillMaxCopy = skillMax
        var dictionaryOfDates : [String: Double] = [:]
        var timestamp : [[Double]] = []
        var skillSorts : [(String , Double)] = []
        var skills : [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var results : [String: [ChartDataEntry]] = [:]
        
        let sequence = DateFunctions.getDateSequence(miniDate: CurrentUserData.miniDate!, currentDate: NSDate())
        
        for i in skillMaxCopy{
            let values = i.value
            let date = values.map({dateFormatter.date(from: $0.0)})
            var skillTimestamps = date.map({Double($0!.timeIntervalSince1970)})
            
            skillTimestamps.sort()
            skillSorts.append((i.key, skillTimestamps[0]))
            
            timestamp.append(skillTimestamps)
            
let newData = SkillManipulation.addDataForEachDay(dateSequence: sequence, skill: i.value)
            skillMaxCopy[i.key] = newData
        }
        let timestamps = timestamp.reduce([], +)
        
        skillSorts = skillSorts.sorted {$0.1 < $1.1}
        skills = skillSorts.map {$0.0}
        
        var keys = Array(Set<Double>(timestamps))
        keys = keys.sorted()
        
        for theKey in keys {
            let keyDate = Date(timeIntervalSince1970: theKey)
            let key = dateFormatter.string(from: keyDate)
            print(key)
            
            for a in skills {
                let i = skillMaxCopy[a]
                if let value = dictionaryOfDates[key] {
                    let oldValue = i!.filter({$0.0 == key}).map({$0.1}).reduce(0, +)
                    if oldValue == 0 {continue}
                    let newValue = oldValue + value
                    dictionaryOfDates[key] = newValue
                    
                    let date = dateFormatter.date(from: key)
                    let timestamp = Double(date!.timeIntervalSince1970)
                    
                    let entry = ChartDataEntry(x: timestamp - CurrentUserData.miniDate!, y: newValue)
                    
                    if results[a] == nil {
                        results[a] = [entry]
                    } else {
                        var chartArray = results[a]
                        chartArray?.append(entry)
                        results[a] = chartArray
                    }
                    
                } else {
                    //Create new value in dictionary and add to the chart data entry
                    let newValue = i!.filter({$0.0 == key}).map({$0.1}).reduce(0, +)
                    if newValue == 0 {continue}
                    dictionaryOfDates[key] = newValue
                    
                    let date = dateFormatter.date(from: key)
                    let timestamp = Double(date!.timeIntervalSince1970)
                    
                    let entry = ChartDataEntry(x: timestamp - CurrentUserData.miniDate!, y: newValue)
                    
                    if results[a] == nil {
                        results[a] = [entry]
                    } else {
                        var chartArray = results[a]
                        chartArray?.append(entry)
                        results[a] = chartArray
                    }
                }
            }
        }
        print(results)
        completion(results)
    }
    
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
    
    
    static func addDataForEachDay (dateSequence: [String], skill : [(date: String, max: Double)]) -> [(date: String, max: Double)] {
        var prevDate : String = "Boop"
        var results : [(date: String, max: Double)] = []
        
        for date in dateSequence {
            var value : Double = 0
            let dateLevel = skill.filter({$0.0 == date})
            if dateLevel.count > 0 {
                value = dateLevel[0].1
            } else {
                let lastValue = results.filter({$0.0 == prevDate})
                
                if lastValue.count > 0 {
                    value = lastValue[0].1
                } else {
                    value = 0
                }
            }
            let result = (date, value)
            results.append(result)
            prevDate = date
        }
        print(results)
        return results
    }
}

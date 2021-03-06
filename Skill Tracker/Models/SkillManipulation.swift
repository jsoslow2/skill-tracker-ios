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
        var totalChartArray : [ChartDataEntry] = []
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var results : [String: [ChartDataEntry]] = [:]
        
        let sequence = DateFunctions.getDateSequence(miniDate: CurrentUserData.miniDate!, currentDate: NSDate())
        
        for i in skillMaxCopy{
            let values = i.value
            let date = values.map({dateFormatter.date(from: $0.0)})
            var skillTimestamps = date.map({Double($0!.timeIntervalSince1970)})
            
            let greaterThan0 = values.filter({$0.1 > 0})
            let dates0 = greaterThan0.map({dateFormatter.date(from: $0.0)})
            var skillTimestamps0 = dates0.map({Double($0!.timeIntervalSince1970)})
            
            skillTimestamps.sort()
            skillTimestamps0.sort()
            skillSorts.append((i.key, skillTimestamps0[0]))
            
            timestamp.append(skillTimestamps)
            
            let newData = SkillManipulation.addDataForEachDay(skillName: i.key, dateSequence: sequence, skill: i.value)
            skillMaxCopy[i.key] = newData
        }
        
        let timestamps = sequence.map({Double(dateFormatter.date(from: $0)!.timeIntervalSince1970)})

        skillSorts = skillSorts.sorted {
            if ($0.1 != $1.1) {
                return ($0.1 < $1.1)
            } else {
                return ($0.0 < $1.0)
            }
        }
        skills = skillSorts.map {$0.0}
        CurrentUserData.skillsSorted = skills
        CurrentUserData.skillsSorted!.append("Total Level")

        
        var keys = Array(Set<Double>(timestamps))
        keys = keys.sorted()
        
        for theKey in keys {
            let keyDate = Date(timeIntervalSince1970: theKey)
            let key = dateFormatter.string(from: keyDate)
            print(key)
            
            for a in skills {
                let i = skillMaxCopy[a]
                if let value = dictionaryOfDates[key] {
                    let onDate = i!.filter({$0.0 == key})
                    let oldValue = onDate.map({$0.1}).reduce(0, +)
                    if onDate.count == 0 {continue}
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
                    let onDate = i!.filter({$0.0 == key})
                    let newValue = onDate.map({$0.1}).reduce(0, +)
                    if onDate.count == 0 {continue}
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
            let maxValue = dictionaryOfDates[key]!
            let entry = ChartDataEntry(x: theKey - CurrentUserData.miniDate!, y: maxValue)
            totalChartArray.append(entry)
        }
        results["Total Level"] = totalChartArray
        print(results)
        print("WTF")
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timestamps = results.map {DateFunctions.stringToTimestamp(date: $0.0, dateFormatter: dateFormatter)}
        CurrentUserData.miniDate = timestamps.min()
        
        return results
    }
    
    static func sumByDate(dates : [(String, Double)], completion: @escaping([ChartDataEntry]) -> Void) {
        let sequence = DateFunctions.getDateSequence(miniDate: CurrentUserData.miniDate!, currentDate: NSDate())
        var results : [(timestamp: Double, value: Double)] = []
        let keys = Set<String>(dates.map{($0.0)})
        var timestamps : [Double] = []
        
        var values : [(String, Double)] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for key in keys {
            let sum = dates.filter({$0.0 == key}).map({$0.1}).reduce(0, +)
            let date = dateFormatter.date(from: key)
            let timeStamp = (date?.timeIntervalSince1970)!
            
            timestamps.append(Double(timeStamp))
            results.append((Double(timeStamp), sum))
            values.append((key, sum))
        }
        
        values = SkillManipulation.addDataForEachDay(skillName: "",  dateSequence: sequence, skill: values)
        print(values)
        print("Spooglewatt")
        
        CurrentUserData.miniDate = timestamps.min()
        
        results = results.sorted(by: {$0.0 < $1.0})
        var dataCleaned : [ChartDataEntry] = []
        for i in 0..<results.count {
            let dataEntry = ChartDataEntry(x: Double(results[i].timestamp) - CurrentUserData.miniDate!, y: (results[i].value as AnyObject).doubleValue)
          dataCleaned.append(dataEntry)
        }
        
        completion(dataCleaned)
    }
    
    
    static func addDataForEachDay (skillName: String, dateSequence: [String], skill : [(date: String, max: Double)]) -> [(date: String, max: Double)] {
        var prevDate : String = "Boop"
        var results : [(date: String, max: Double)] = []
        var halfValue : Double = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for date in dateSequence {
            var value : Double = 0
            let dateLevel = skill.filter({$0.0 == date})
            if dateLevel.count > 0 {
                value = dateLevel[0].1
                halfValue = 0
            } else {
                let lastValue = results.filter({$0.0 == prevDate})
                
                if lastValue.count > 0 {
                    
                    value = lastValue[0].1
                    if (halfValue == 0) {
                        halfValue = value * 0.5
                    }
                    value = value - (value - halfValue) * 0.01
                    
                    let timestamp = dateFormatter.date(from: date)?.timeIntervalSince1970
                    let timestampString = timestamp?.description.components(separatedBy: ".").first
                    
                    SkillService.levelDownSkill(uid: CurrentUserData.uid, skillName: skillName, newLevel: value, timestamp: timestampString!)
                    
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

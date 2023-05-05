//
//  SleepStats.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 20/4/23.
//

import Foundation

struct SleepStat: Identifiable, Hashable {
    let id = UUID()
    let weekOfYear: String
    let timeOfSleep: String
    let wakeUpTime: String
    var sleepDuration: Double
    var createAt: Date
    
//    init(weekOfYear: String, timeOfSleep: String, wakeUpTime: String, sleepDuration: Double, createAt: Date) {
//        self.weekOfYear = weekOfYear
//        self.timeOfSleep = timeOfSleep
//        self.wakeUpTime = wakeUpTime
//        self.sleepDuration = sleepDuration
//        self.createAt = createAt
//    }
}

//
//  SleepStats.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 20/4/23.
//

import Foundation

struct SleepStat: Identifiable, Hashable {
    let id = UUID()
    var weekOfYear: String
    var timeOfSleep: String
    var wakeUpTime: String
    var sleepDuration: Double
    var dateString: String
    var year: String
    var date: Date
}

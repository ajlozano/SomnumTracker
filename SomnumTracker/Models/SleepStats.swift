//
//  SleepStats.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 20/4/23.
//

import Foundation

struct SleepStats: Identifiable, Hashable {
    let id = UUID()
    let weekOfYear: String
    let timeOfSleep: String
    let wakeupTime: String
    var sleepDuration: Float
    let createAt: Date
}

//
//  SleepStats.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 20/4/23.
//

import Foundation

struct SleepStats: Identifiable {
    let id = UUID()
    let weekDay: String
    let timeOfSleep: String
    let wakeupTime: String
    let sleepDuration: Float
    let createAt: Date?
}

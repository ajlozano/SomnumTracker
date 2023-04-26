//
//  SleepStatsHistory.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 26/4/23.
//

import SwiftUI
import Charts
import Foundation

struct SleepStatsHistory: View {
    let list = [SleepStats(weekDay: "1/1", timeOfSleep: "01:00", wakeupTime: "02:00", sleepDuration: 8, createAt: nil),
                SleepStats(weekDay: "1/2", timeOfSleep: "02:00", wakeupTime: "03:00", sleepDuration: 7.5, createAt: nil),
                SleepStats(weekDay: "1/3", timeOfSleep: "03:00", wakeupTime: "04:00", sleepDuration: 9, createAt: nil),
                SleepStats(weekDay: "1/4", timeOfSleep: "10:50", wakeupTime: "12:00", sleepDuration: 7, createAt: nil),
                SleepStats(weekDay: "1/5", timeOfSleep: "12:45", wakeupTime: "10:00", sleepDuration: 8.5, createAt: nil),
                SleepStats(weekDay: "1/6", timeOfSleep: "07:30", wakeupTime: "21:00", sleepDuration: 6, createAt: nil),
                SleepStats(weekDay: "10/7", timeOfSleep: "20:25", wakeupTime: "22:13", sleepDuration: 6.5, createAt: nil)]
    
    var body: some View {
        Chart(list) { sleepStatModel in
            
            AreaMark(
                x: .value("Weekday", sleepStatModel.weekDay),
                y: .value("Sleep Duration", sleepStatModel.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlueLight))
            .interpolationMethod(.cardinal)
            LineMark(
                x: .value("Weekday", sleepStatModel.weekDay),
                y: .value("Sleep Duration", sleepStatModel.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlue))
            .interpolationMethod(.cardinal)
            PointMark(
                x: .value("Weekday", sleepStatModel.weekDay),
                y: .value("Sleep Duration", sleepStatModel.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlue))
            .symbolSize(20)
        }.chartYAxis {
            AxisMarks(position: .leading)
        }
    }
}


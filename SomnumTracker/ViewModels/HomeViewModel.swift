//
//  HomeViewModel.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 27/4/23.
//

import Foundation

struct HomeViewModel {
    var sleepStatList: ObservableObject<[SleepStats]?> = ObservableObject(nil)
    
    let list = [SleepStats(weekDay: "5/1", timeOfSleep: "01:00", wakeupTime: "02:00", sleepDuration: 8, createAt: nil),
                SleepStats(weekDay: "5/2", timeOfSleep: "02:00", wakeupTime: "03:00", sleepDuration: 7.5, createAt: nil),
                SleepStats(weekDay: "5/3", timeOfSleep: "03:00", wakeupTime: "04:00", sleepDuration: 9, createAt: nil),
                SleepStats(weekDay: "5/4", timeOfSleep: "10:50", wakeupTime: "12:00", sleepDuration: 7, createAt: nil),
                SleepStats(weekDay: "5/5", timeOfSleep: "12:45", wakeupTime: "10:00", sleepDuration: 8.5, createAt: nil),
                SleepStats(weekDay: "5/6", timeOfSleep: "07:30", wakeupTime: "21:00", sleepDuration: 6, createAt: nil),
                SleepStats(weekDay: "5/7", timeOfSleep: "20:25", wakeupTime: "22:13", sleepDuration: 6.5, createAt: nil)]
    
    func getSleepStatList() {
        self.sleepStatList.value = list
    }
}

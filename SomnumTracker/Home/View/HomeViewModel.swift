//
//  HomeViewModel.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 27/4/23.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var sleepStats = [SleepStat]() 
    let weekOfYear = Calendar.current.component(.weekOfYear, from: Date(timeIntervalSinceNow: 0))
    
    init(){
        //sleepStatList.value = sleepStats
        //getSleepStatList()
    }
    
    func getSleepStatList() {
        //self.sleepStatList.value = sleepStats
        self.sleepStats = [
            SleepStat(weekOfYear: "/M", timeOfSleep: "01:00", wakeUpTime: "02:00", sleepDuration: 8, createAt:       CustomDateFormatter.dateFormatter.date(from: "20/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/T", timeOfSleep: "02:00", wakeUpTime: "03:00", sleepDuration: 7.5, createAt: CustomDateFormatter.dateFormatter.date(from: "21/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/W", timeOfSleep: "03:00", wakeUpTime: "04:00", sleepDuration: 9, createAt: CustomDateFormatter.dateFormatter.date(from: "22/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/TH", timeOfSleep: "10:50", wakeUpTime: "12:00", sleepDuration: 7, createAt: CustomDateFormatter.dateFormatter.date(from: "23/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/F", timeOfSleep: "12:45", wakeUpTime: "10:00", sleepDuration: 8.5, createAt: CustomDateFormatter.dateFormatter.date(from: "24/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/S", timeOfSleep: "07:30", wakeUpTime: "21:00", sleepDuration: 6, createAt: CustomDateFormatter.dateFormatter.date(from: "25/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/S", timeOfSleep: "20:25", wakeUpTime: "22:13", sleepDuration: 6.5, createAt: CustomDateFormatter.dateFormatter.date(from: "20/12/2023") ?? Date())]
    }
}

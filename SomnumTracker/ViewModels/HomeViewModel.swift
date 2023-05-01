//
//  HomeViewModel.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 27/4/23.
//

import Foundation

struct HomeViewModel {
    var sleepStatList: ObservableObject<[SleepStats]?> = ObservableObject(nil)
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }()
    
    func formatDate(_ date: Date) -> String {
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.day, .month], from: date)
        guard let day = dateComponents.day, let month = dateComponents.month else {
            return "-"
        }
        return "\(day)/\(month)"
    }
    
    let weekOfYear = Calendar.current.component(.weekOfYear, from: Date(timeIntervalSinceNow: 0))
    
    let list = [
                SleepStats(weekDay: "5/M", timeOfSleep: "01:00", wakeupTime: "02:00", sleepDuration: 8, createAt:       dateFormatter.date(from: "20/04/2023") ?? Date()),
                SleepStats(weekDay: "5/T", timeOfSleep: "02:00", wakeupTime: "03:00", sleepDuration: 7.5, createAt: dateFormatter.date(from: "21/04/2023") ?? Date()),
                SleepStats(weekDay: "5/3", timeOfSleep: "03:00", wakeupTime: "04:00", sleepDuration: 9, createAt: dateFormatter.date(from: "22/04/2023") ?? Date()),
                SleepStats(weekDay: "5/4", timeOfSleep: "10:50", wakeupTime: "12:00", sleepDuration: 7, createAt: dateFormatter.date(from: "23/04/2023") ?? Date()),
                SleepStats(weekDay: "5/5", timeOfSleep: "12:45", wakeupTime: "10:00", sleepDuration: 8.5, createAt: dateFormatter.date(from: "24/04/2023") ?? Date()),
                SleepStats(weekDay: "5/6", timeOfSleep: "07:30", wakeupTime: "21:00", sleepDuration: 6, createAt: dateFormatter.date(from: "25/04/2023") ?? Date()),
                SleepStats(weekDay: "5/7", timeOfSleep: "20:25", wakeupTime: "22:13", sleepDuration: 6.5, createAt: dateFormatter.date(from: "20/12/2023") ?? Date())]
    
    func getSleepStatList() {
        self.sleepStatList.value = list
    }
}

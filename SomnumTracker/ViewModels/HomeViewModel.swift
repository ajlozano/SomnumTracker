//
//  HomeViewModel.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 27/4/23.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var sleepStatList: CustomObservableObject<[SleepStats]?> = CustomObservableObject(nil)
    @Published var sleepStats = [SleepStats]() {
        didSet {
            didChange.send(self)
            print("did Set")
        }
    }
    
    let didChange = PassthroughSubject<HomeViewModel, Never>()
    
    let weekOfYear = Calendar.current.component(.weekOfYear, from: Date(timeIntervalSinceNow: 0))
    
    init(){
        //sleepStatList.value = sleepStats
        getSleepStatList()
    }
    
    func getSleepStatList() {
        //self.sleepStatList.value = sleepStats
        self.sleepStats = [
            SleepStats(weekOfYear: "/M", timeOfSleep: "01:00", wakeupTime: "02:00", sleepDuration: 8, createAt:       CustomDateFormatter.dateFormatter.date(from: "20/04/2023") ?? Date()),
            SleepStats(weekOfYear: "5/T", timeOfSleep: "02:00", wakeupTime: "03:00", sleepDuration: 7.5, createAt: CustomDateFormatter.dateFormatter.date(from: "21/04/2023") ?? Date()),
            SleepStats(weekOfYear: "5/W", timeOfSleep: "03:00", wakeupTime: "04:00", sleepDuration: 9, createAt: CustomDateFormatter.dateFormatter.date(from: "22/04/2023") ?? Date()),
            SleepStats(weekOfYear: "5/TH", timeOfSleep: "10:50", wakeupTime: "12:00", sleepDuration: 7, createAt: CustomDateFormatter.dateFormatter.date(from: "23/04/2023") ?? Date()),
            SleepStats(weekOfYear: "5/F", timeOfSleep: "12:45", wakeupTime: "10:00", sleepDuration: 8.5, createAt: CustomDateFormatter.dateFormatter.date(from: "24/04/2023") ?? Date()),
            SleepStats(weekOfYear: "5/S", timeOfSleep: "07:30", wakeupTime: "21:00", sleepDuration: 6, createAt: CustomDateFormatter.dateFormatter.date(from: "25/04/2023") ?? Date()),
            SleepStats(weekOfYear: "5/S", timeOfSleep: "20:25", wakeupTime: "22:13", sleepDuration: 6.5, createAt: CustomDateFormatter.dateFormatter.date(from: "20/12/2023") ?? Date())]
    }
}

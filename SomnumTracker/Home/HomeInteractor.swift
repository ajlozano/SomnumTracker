//
//  HomeInteractor.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 3/5/23.
//  
//

import Foundation

class HomeInteractor: HomeInteractorInputProtocol {
    
    // MARK: Properties
    weak var presenter: HomeInteractorOutputProtocol?
    var sleepStatsWeek = [SleepStat]()
    var sleepStatsDb = [SleepStat]()
   
    func resetEntryValues() {
        if let sleepDate = CustomDateFormatter.timeFormat.date(from: Constants.defaultSleepTime),
           let wakeUpDate = CustomDateFormatter.timeFormat.date(from: Constants.defaultWakeUpTime){
            presenter?.entryValuesReset(sleepDate, wakeUpDate, Constants.defaultSleepDuration + " hours")
        }
    }
    
    func updateSleepDurationFromEntryChanges(sleepTime: Date, wakeUpTime: Date) {
        let sleepDuration = computeTimeInHours(recent: wakeUpTime, previous: sleepTime)
        presenter?.entryValuesChanged("\(sleepDuration) hours")
    }
        
    func fetchSleepStats() {
        sleepStatsDb.removeAll()
        
        DataPersistence.shared.loadData { sleepData in
            let calendar = CustomDateFormatter.shared.getCalendar()
            let todayComponent = calendar.dateComponents([.day, .month, .weekOfYear, .weekday, .year], from: Date())
            
            for data in sleepData {
                let stat = SleepStat(
                    weekOfYear: data.weekOfYear ?? "-",
                    timeOfSleep: data.timeOfSleep ?? "-",
                    wakeUpTime: data.wakeUpTime ?? "-",
                    sleepDuration: data.sleepDuration,
                    dateString: data.dateString ?? "-",
                    year: data.year ?? "-",
                    date: data.date ?? calendar.date(from: todayComponent)!
                    )
                sleepStatsDb.append(stat)
            }
            
            updateSleepStatsFromDate(date: calendar.date(from: todayComponent)!)
            presenter?.sleepStatsFetched(sleepStatsWeek)
        }
    }
    
    func addSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {
        let sleepDurString = sleepDuration.replacingOccurrences(of: " hours", with: "")
        
        let calendar = CustomDateFormatter.shared.getCalendar()
        
        let dateComponent = calendar.dateComponents([.day, .month, .weekOfYear, .year], from: date)

        let sleepTimeComponent = calendar.dateComponents([.hour, .minute,], from: sleepTime)
        let wakeUpTimeComponent = calendar.dateComponents([.hour, .minute,], from: wakeUpTime)
        
        let weekOfYearString = "\(dateComponent.weekOfYear!)"

        let dateString = CustomDateFormatter.shared.formatDayMonth(dateComponent.day!, dateComponent.month!)
        
        let sleepStat = SleepStat(
            weekOfYear: weekOfYearString,
            timeOfSleep: CustomDateFormatter.shared.formatHourMinute(sleepTimeComponent.hour!, sleepTimeComponent.minute!),
            wakeUpTime: CustomDateFormatter.shared.formatHourMinute(wakeUpTimeComponent.hour!, wakeUpTimeComponent.minute!),
            sleepDuration: Double(sleepDurString) ?? 0.0,
            dateString: dateString,
            year: "\(dateComponent.year!)",
            date: calendar.date(from: dateComponent)!)

        if(sleepStatsDb.count >= Constants.maxSleepEntries) {
            if let olderSleepStat = sleepStatsDb.min(by: { $0.date < $1.date }) {
                DataPersistence.shared.deleteData(olderSleepStat)
                sleepStatsDb.removeAll(where: {$0.dateString == olderSleepStat.dateString})
            }
        }
        
        if let sleepStatFoundIndex = sleepStatsDb.firstIndex(where: { ($0.dateString == dateString && $0.year == "\(dateComponent.year!)") }) {
            DataPersistence.shared.deleteData(sleepStatsDb[sleepStatFoundIndex])
            sleepStatsDb.remove(at: sleepStatFoundIndex)
        }
        
        sleepStatsDb.append(sleepStat)
        
        DataPersistence.shared.saveData(sleepStat) { _ in
            let todayComponent = calendar.dateComponents([.day, .month, .weekOfYear, .weekday, .year], from: Date())
            updateSleepStatsFromDate(date: calendar.date(from: todayComponent)!)
            presenter?.sleepStatsFetched(sleepStatsWeek)
        }
    }
    
    func getNextWeek(date: Date) {
        let calendar = CustomDateFormatter.shared.getCalendar()
        let components = calendar.dateComponents([.day, .month, .weekOfYear, .year], from: date)
        guard let currentDate = calendar.date(from: components) else {
            print(" Error getting date from getLastWeek")
            return
        }
        
        if let nextWeekDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) {
            let todayComponent = calendar.dateComponents([.day, .month, .weekOfYear, .year], from: Date())
            let nextWeekComponent = calendar.dateComponents([.day, .month, .weekOfYear, .year], from: nextWeekDate)
            if (calendar.date(from: todayComponent)! > nextWeekDate) {
                updateSleepStatsFromDate(date: calendar.date(from: nextWeekComponent)!)
                presenter?.sleepStatsFetched(sleepStatsWeek)
            }
        }
    }
    
    func getLastWeek(date: Date) {
        let calendar = CustomDateFormatter.shared.getCalendar()
        let components = calendar.dateComponents([.day, .month, .weekOfYear, .year], from: date)
        guard let currentDate = calendar.date(from: components) else {
            print(" Error getting date from getLastWeek")
            return
        }

        if let lastWeekDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate) {
            let lastWeekComponent = calendar.dateComponents([.day, .month, .weekOfYear, .year], from: lastWeekDate)
            
            updateSleepStatsFromDate(date: calendar.date(from: lastWeekComponent)!)
            presenter?.sleepStatsFetched(sleepStatsWeek)
        }
    }
    
    private func updateSleepStatsFromDate(date: Date) {
        let calendar = CustomDateFormatter.shared.getCalendar()
             
        if let firstDayOfWeek = getFirstDayFromWeekOfYear(date: date) {
            sleepStatsWeek.removeAll()

            for i in 0...6 {
                guard let currentDate = calendar.date(byAdding: .day, value: i, to: firstDayOfWeek) else {
                    return
                }
                
                let currentComponent = calendar.dateComponents([.day, .month, .weekOfYear, .year], from: currentDate)
                let currentDateString = CustomDateFormatter.shared.formatDayMonth(currentComponent.day!, currentComponent.month!)
                if let statFromCurrentDate = sleepStatsDb.first(
                    where: { ($0.dateString == currentDateString && $0.year == "\(currentComponent.year!)") }) {
                    sleepStatsWeek.append(statFromCurrentDate)
                } else {
                    let sleepStat = SleepStat(
                        weekOfYear: "\(currentComponent.weekOfYear!)",
                        timeOfSleep: "-",
                        wakeUpTime: "-",
                        sleepDuration: 0.0,
                        dateString: currentDateString,
                        year: "\(currentComponent.year!)",
                        date: calendar.date(from: currentComponent)!)

                    sleepStatsWeek.append(sleepStat)
                }
                
            }
        }
    }
    
    private func getFirstDayFromWeekOfYear(date: Date) -> Date? {
        let calendar = CustomDateFormatter.shared.getCalendar()

        let weekdayComponents = calendar.dateComponents([.day, .month, .weekday, .weekOfYear, .year], from: date)
        
        var compontentsToSubstract = DateComponents()
        compontentsToSubstract.day = -(weekdayComponents.weekday! - calendar.firstWeekday)
        var beginningOfWeek = calendar.date(byAdding: compontentsToSubstract, to: date)
        var components = DateComponents()
        components.day = calendar.dateComponents([.day], from: beginningOfWeek!).day!
        components.month = calendar.dateComponents([.month], from: beginningOfWeek!).month!
        components.year = calendar.dateComponents([.year], from: beginningOfWeek!).year!
        beginningOfWeek = calendar.date(from: components)
        
        return beginningOfWeek
    }
    
    private func computeTimeInHours(recent: Date, previous: Date) -> String {
        var delta = recent.timeIntervalSince(previous) / 3600
        if delta < 0 {
            delta += 24.0
        }
        return String(format: "%.2f", delta)
    }
}


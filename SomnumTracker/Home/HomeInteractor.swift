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
    var localDatamanager: HomeLocalDataManagerInputProtocol?
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol?

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
        DataPersistence.shared.loadTitles { sleepData in
            for data in sleepData {
                let stat = SleepStat(
                    weekOfYear: data.weekOfYear ?? "-",
                    timeOfSleep: data.timeOfSleep ?? "-",
                    wakeUpTime: data.wakeUpTime ?? "-",
                    sleepDuration: data.sleepDuration,
                    dateString: data.dateString ?? "-",
                    year: data.year ?? "-",
                    date: data.date ?? Date()
                    )
                sleepStatsDb.append(stat)
            }
            
            let dateComponents = Calendar.current.dateComponents([.year, .weekOfYear, .day, .month], from: Date())
            
            updateSleepStatsFromDate(weekOfYear: dateComponents.weekOfYear!, year: dateComponents.year!)
            presenter?.sleepStatsFetched(sleepStatsWeek)
        }
    }
    
    func addSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {
        let sleepDurString = sleepDuration.replacingOccurrences(of: " hours", with: "")
        let weekOfYearString = "\(Calendar.current.component(.weekOfYear, from: date))"
        let dateString = CustomDateFormatter.shared.formatDayMonth(date)
        
        let sleepStat = SleepStat(
            weekOfYear: weekOfYearString,
            timeOfSleep: CustomDateFormatter.shared.formatHourMinute(sleepTime),
            wakeUpTime: CustomDateFormatter.shared.formatHourMinute(wakeUpTime),
            sleepDuration: Double(sleepDurString) ?? 0.0,
            dateString: dateString,
            year: CustomDateFormatter.shared.formatYear(date),
            date: date)

        if(sleepStatsDb.count >= Constants.maxSleepEntries) {
            if let olderSleepStat = sleepStatsDb.min(by: { $0.date < $1.date }) {
                DataPersistence.shared.deleteData(olderSleepStat)
                sleepStatsDb.removeAll(where: {$0.dateString == olderSleepStat.dateString})
            }
        }
        
        if let sleepStatFoundIndex = sleepStatsDb.firstIndex(where: {$0.dateString == dateString}) {
            DataPersistence.shared.deleteData(sleepStatsDb[sleepStatFoundIndex])
            sleepStatsDb.remove(at: sleepStatFoundIndex)
        }
        
        sleepStatsDb.append(sleepStat)
        
        DataPersistence.shared.saveData(sleepStat) { _ in
            for stat in sleepStatsDb {
                print("\(stat.sleepDuration) - \(stat.year) - \(stat.weekOfYear) - \(stat.dateString) - \(stat.date)")
            }
            
            let dateComponents = Calendar.current.dateComponents([.year, .weekOfYear], from: date)
            updateSleepStatsFromDate(weekOfYear: Int(weekOfYearString)!, year: dateComponents.year!)
            presenter?.sleepStatsFetched(sleepStatsWeek)
        }
    }
    
    func getNextWeek(weekOfYear: String, year: String) {
        let components = DateComponents(weekOfYear: Int(weekOfYear), yearForWeekOfYear: Int(year))
        guard let date = Calendar.current.date(from: components) else {
            print(" Error getting date from getLastWeek")
            return
        }
        
        if let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: date) {
            let dateComponents = Calendar.current.dateComponents([.year, .weekOfYear], from: nextWeekDate)
            guard let newWeekOfYear = dateComponents.weekOfYear, let newYear = dateComponents.year else {
                print("error getting year and weekOfYear from dateComponents.")
                return
            }
            
            let currentWeekOfYear = Calendar.current.component(.weekOfYear, from: Date())
            print("old: \(currentWeekOfYear)")
            print("new: \(newWeekOfYear)")
            if (Date() > date) {
                updateSleepStatsFromDate(weekOfYear: newWeekOfYear, year: newYear)
                presenter?.sleepStatsFetched(sleepStatsWeek)
            }
        }
    }
    
    func getLastWeek(weekOfYear: String, year: String) {
        let components = DateComponents(weekOfYear: Int(weekOfYear)!, yearForWeekOfYear: Int(year)!)
        guard let date = Calendar.current.date(from: components) else {
            print(" Error getting date from getLastWeek")
            return
        }

        if let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: date) {
            let dateComponents = Calendar.current.dateComponents([.year, .weekOfYear], from: lastWeekDate)
            guard let newWeekOfYear = dateComponents.weekOfYear, let newYear = dateComponents.year else {
                print("error getting year and weekOfYear from dateComponents.")
                return
            }
            print(newWeekOfYear)
            print(newYear)
            updateSleepStatsFromDate(weekOfYear: newWeekOfYear, year: newYear)
            presenter?.sleepStatsFetched(sleepStatsWeek)
       }
    }
    
    private func updateSleepStatsFromDate(weekOfYear: Int, year: Int) {
        if let firstDayOfWeek = getFirstDayFromWeekOfYear(from: Calendar.current.date(from: DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year))!) {
            
            sleepStatsWeek.removeAll()
            
            for i in 0...6 {
                guard let currentDate = Calendar.current.date(byAdding: .day, value: i, to: firstDayOfWeek) else {
                    return
                }
                //print(firstDayOfWeek)
                //print(currentDate)
                var calendar = Calendar(identifier: .gregorian)
                calendar.firstWeekday = 2
                let currentComponent = calendar.dateComponents([.day], from: currentDate)
                
                //print(currentComponent.day)
                let currentDateString = CustomDateFormatter.shared.formatDayMonth(currentDate)
                //print(currentDateString)
                
                if let statFromCurrentDate = sleepStatsDb.first(where: { $0.dateString == currentDateString }) {
                    sleepStatsWeek.append(statFromCurrentDate)
                } else {
                    
                    let sleepStat = SleepStat(
                        weekOfYear: "\(weekOfYear)",
                        timeOfSleep: "-",
                        wakeUpTime: "-",
                        sleepDuration: 0.0,
                        dateString: currentDateString,
                        year: "\(year)",
                        date: currentDate)

                    sleepStatsWeek.append(sleepStat)
                }
            }
        }
    }
    
    private func getFirstDayFromWeekOfYear(from date: Date) -> Date? {
        let today = date
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.firstWeekday = 2
        gregorian.timeZone = TimeZone.current

        let weekdayComponents = gregorian.component(.weekday, from: today)
        
        var compontentsToSubstract = DateComponents()
        // Sunday -> -(weekdayComponetns.weekday - gregorian.firstWeekday)
        // Monday -> -(weekdayComponetns.weekday - gregorian.firstWeekday - 1)
        compontentsToSubstract.day = -(weekdayComponents - gregorian.firstWeekday - 1)
        var beginningOfWeek = gregorian.date(byAdding: compontentsToSubstract, to: today)
        var components = DateComponents()
        components.timeZone = TimeZone.current
        components.day = gregorian.dateComponents([.day], from: beginningOfWeek!).day!
        components.month = gregorian.dateComponents([.month], from: beginningOfWeek!).month!
        components.year = gregorian.dateComponents([.year], from: beginningOfWeek!).year!
        //var components = gregorian.dateComponents([.year, .month, .day, .weekday, .timeZone, .weekOfYear], from: beginningOfWeek!)
        beginningOfWeek = gregorian.date(from: components)
        print(beginningOfWeek)
        print("\(gregorian.dateComponents([.day], from: beginningOfWeek!).day!)")
        
        return beginningOfWeek
    }
    
    private func computeTimeInHours(recent: Date, previous: Date) -> String {
        var delta = recent.timeIntervalSince(previous) / 3600
        if delta < 0 {
            delta += 24.0
        }
        return String(format: "%.2f", delta)
    }
    
    private func getCurrentCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = NSLocale.current
        calendar.firstWeekday = 2
        return calendar
    }
}

extension HomeInteractor: HomeRemoteDataManagerOutputProtocol {
    // TODO: Implement use case methods
}

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
            
            var calendar = Calendar.current
            calendar.locale = NSLocale.current
            
            let dateComponents = calendar.dateComponents([.year, .weekOfYear], from: Date())
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
            
            if (newWeekOfYear <= Calendar.current.component(.weekOfYear, from: Date())) {
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
            updateSleepStatsFromDate(weekOfYear: newWeekOfYear, year: newYear)
            presenter?.sleepStatsFetched(sleepStatsWeek)
       }
    }
    
    private func updateSleepStatsFromDate(weekOfYear: Int, year: Int) {
        if let firstDayOfWeek = getFirstDayFromWeekOfYear(from: weekOfYear, year: year) {
            sleepStatsWeek.removeAll()

            for i in 0...6 {
                guard let currentDate = Calendar.current.date(byAdding: .day, value: i, to: firstDayOfWeek) else {
                    return
                }
                
                let currentDateString = CustomDateFormatter.shared.formatDayMonth(currentDate)
                
                if let statFromCurrentDate = sleepStatsDb.first(where: { $0.dateString == currentDateString }) {
                    sleepStatsWeek.append(statFromCurrentDate)
                } else {
                    let sleepStat = SleepStat(
                        weekOfYear: "\(weekOfYear)",
                        timeOfSleep: "-",
                        wakeUpTime: "-",
                        sleepDuration: 0.0,
                        dateString: CustomDateFormatter.shared.formatDayMonth(currentDate),
                        year: "\(year)",
                        date: currentDate)

                    sleepStatsWeek.append(sleepStat)
                }
            }
        }
    }
    
    private func getFirstDayFromWeekOfYear(from week: Int, year: Int? = Calendar.current.component(.year, from: Date()), locale: Locale? = nil) -> Date? {
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = NSLocale.current
        calendar.firstWeekday = 2
        let dateComponents = DateComponents(calendar: calendar, year: year, weekday: calendar.firstWeekday, weekOfYear: week)
        return calendar.date(from: dateComponents)
    }
    
    private func computeTimeInHours(recent: Date, previous: Date) -> String {
        var delta = recent.timeIntervalSince(previous) / 3600
        if delta < 0 {
            delta += 24.0
        }
        return String(format: "%.2f", delta)
    }
}

extension HomeInteractor: HomeRemoteDataManagerOutputProtocol {
    // TODO: Implement use case methods
}

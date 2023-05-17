//
//  HomeInteractor.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 3/5/23.
//  
//

import Foundation

class HomeInteractor: HomeInteractorInputProtocol {
    
    // 4 - Rellenar en vacío los 7 días de esa semana
    // 5 - Leer datos y asociar los de la semana en el array de los 7 días.
    
    // MARK: Properties
    weak var presenter: HomeInteractorOutputProtocol?
    var localDatamanager: HomeLocalDataManagerInputProtocol?
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol?

    var sleepStatsWeek = [SleepData]()
    var sleepStatsDb = [SleepData]()
    
    // Data persitence context
    let context = DataPersistence.shared.context
   
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
            sleepStatsDb = sleepData
            
            let dateComponents = Calendar.current.dateComponents([.year, .weekOfYear], from: Date())
            updateSleepStatsFromDate(weekOfYear: dateComponents.weekOfYear!, year: dateComponents.year!)
            presenter?.sleepStatsFetched(sleepStatsWeek)
        }
    }
    
    func addSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {
        let sleepDur = sleepDuration.replacingOccurrences(of: " hours", with: "")
        let weekOfYear = "\(Calendar.current.component(.weekOfYear, from: date))"
        let dateString = CustomDateFormatter.shared.formatDayMonth(date)
        
        let sleepData = SleepData(context: context)
        sleepData.weekOfYear = weekOfYear
        sleepData.date = date
        sleepData.year = CustomDateFormatter.shared.formatYear(date)
        sleepData.dateString = dateString
        sleepData.timeOfSleep = CustomDateFormatter.shared.formatHourMinute(sleepTime)
        sleepData.wakeUpTime = CustomDateFormatter.shared.formatHourMinute(wakeUpTime)
        sleepData.sleepDuration = Double(sleepDur) ?? 0.0

        if(sleepStatsDb.count >= Constants.maxSleepEntries) {
            if let olderSleepStat = sleepStatsDb.min(by: { $0.date! < $1.date! }) {
                DataPersistence.shared.deleteData(olderSleepStat)
                sleepStatsDb.removeAll(where: {$0.dateString == olderSleepStat.dateString})
            }
        }
        
        if let sleepStatFoundIndex = sleepStatsDb.firstIndex(where: {$0.dateString == dateString}) {
            DataPersistence.shared.deleteData(sleepStatsDb[sleepStatFoundIndex])
            sleepStatsDb.remove(at: sleepStatFoundIndex)
        }
        
        sleepStatsDb.append(sleepData)
        
        DataPersistence.shared.saveData(sleepStatsDb) { _ in
            for sleepStat in sleepStatsDb {
                print("\(sleepStat.sleepDuration) - \(sleepStat.year) - \(sleepStat.weekOfYear) - \(sleepStat.dateString) - \(sleepStat.date)")
            }
            
            let dateComponents = Calendar.current.dateComponents([.year, .weekOfYear], from: sleepData.date!)
            updateSleepStatsFromDate(weekOfYear: dateComponents.weekOfYear!, year: dateComponents.year!)
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
//            print("FROM: \(date)")
//            print("TO: \(nextWeekDate)")
//            let currentWeek = Calendar.current.component(.weekOfYear, from: Date())
//            let nextWeek = Calendar.current.component(.weekOfYear, from: nextWeekDate)
            //if (nextWeek <= currentWeek) {
                updateSleepStatsFromDate(weekOfYear: dateComponents.weekOfYear!, year: dateComponents.year!)
                presenter?.sleepStatsFetched(sleepStatsWeek)
            //}
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
        //print("current date 2 \(date)")
        if let firstDayOfWeek = getFirstDayFromWeekOfYear(from: weekOfYear, year: year) {
            //print("first day of week \(firstDayOfWeek)")
            sleepStatsWeek.removeAll()
            //sleepStatsWeek.sort { $0.date! < $1.date! }

            for i in 0...6 {
                //let sleepData = SleepData(context: DataPersistence.shared.context)
                let currentDate = Calendar.current.date(byAdding: .day, value: i, to: firstDayOfWeek)
                let currentDateString = CustomDateFormatter.shared.formatDayMonth(currentDate!)
                
                if let statFromCurrentDate = sleepStatsDb.first(where: { $0.dateString == currentDateString }) {
                    sleepStatsWeek.append(statFromCurrentDate)
                } else {
                    let sleepData = SleepData(context: context)
                    
                    sleepData.dateString = CustomDateFormatter.shared.formatDayMonth(currentDate!)
                    
                    sleepData.weekOfYear = "\(weekOfYear)"
                    sleepData.date = currentDate
                    sleepData.year = "\(year)"
                    sleepData.timeOfSleep = "-"
                    sleepData.wakeUpTime = "-"
                    sleepData.sleepDuration = 0.0

                    sleepStatsWeek.append(sleepData)
                }
            }
        }
    }
    
    private func getFirstDayFromWeekOfYear(from week: Int, year: Int? = Calendar.current.component(.year, from: Date()), locale: Locale? = nil) -> Date? {
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = NSLocale.current
        let dateComponents = DateComponents(calendar: calendar, year: year, weekday: 1, weekOfYear: week)
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

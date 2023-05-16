//
//  HomeInteractor.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 3/5/23.
//  
//

import Foundation

class HomeInteractor: HomeInteractorInputProtocol {
    // TODO: Pasos para extraer datos:
    // 1 - Leer datos de almacenamiento interno
    // 2 - Buscar datos de la semana actual a partir del número de semana y año
    // 3 - Obtener cual es el primer día de esa semana.
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
            print(sleepStatsDb)
            updateSleepStatsFromDate(Date())

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
        
        // TODO: Añadir filtro para que se eliminen las entradas anteriores a hace un año
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
            updateSleepStatsFromDate(sleepData.date!)
            presenter?.sleepStatsFetched(sleepStatsWeek)
        }
    }
    
    private func updateSleepStatsFromDate(_ date: Date) {
        if let firstDayOfWeek = getFirstDayFromWeekOfYear(from: Calendar.current.component(.weekOfYear, from: date)) {
            sleepStatsWeek.removeAll()
            //sleepStatsWeek.sort { $0.date! < $1.date! }
            print(sleepStatsWeek.count)
            
            for i in 0...6 {
                //let sleepData = SleepData(context: DataPersistence.shared.context)
                let currentDate = Calendar.current.date(byAdding: .day, value: i, to: firstDayOfWeek)
                let currentDateString = CustomDateFormatter.shared.formatDayMonth(currentDate!)
                
                if let statFromCurrentDate = sleepStatsDb.first(where: { $0.dateString == currentDateString }) {
                    sleepStatsWeek.append(statFromCurrentDate)
                    print("current Stat")
                } else {
                    let sleepData = SleepData(context: context)
                    
                    sleepData.dateString = CustomDateFormatter.shared.formatDayMonth(currentDate!)
                    
                    sleepData.weekOfYear = "\(Calendar.current.component(.weekOfYear, from: date))"
                    sleepData.date = currentDate
                    sleepData.year = "\(Calendar.current.component(.year, from: date))"
                    sleepData.timeOfSleep = "-"
                    sleepData.wakeUpTime = "-"
                    sleepData.sleepDuration = 0.0
                    
                    sleepStatsWeek.append(sleepData)
                    print(sleepData.year)
                    print("Void stat")
                }
            }
            
            print(sleepStatsWeek)
        }

    }
    
    private func getFirstDayFromWeekOfYear(from week: Int, year: Int? = Calendar.current.component(.year, from: Date()), locale: Locale? = nil) -> Date? {
        var calendar = Calendar.current
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

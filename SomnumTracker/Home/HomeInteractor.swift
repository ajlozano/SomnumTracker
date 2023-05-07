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

    var sleepStatsWeek = [SleepStat(), SleepStat(), SleepStat(), SleepStat(), SleepStat(), SleepStat(), SleepStat()]
    
    // This should be the complete internal data
    var sleepStatsDb = [SleepStat]()
//        SleepStat(weekOfYear: "\(Calendar.current.component(.weekOfYear, from: CustomDateFormatter.dateFormat.date(from: "06/05/2023") ?? Date()))", timeOfSleep: "01:00", wakeUpTime: "07:00", sleepDuration: 6, dateString: "06/05/2023"),
//        SleepStat(weekOfYear: "\(Calendar.current.component(.weekOfYear, from: CustomDateFormatter.dateFormat.date(from: "07/05/2023") ?? Date()))", timeOfSleep: "23:00", wakeUpTime: "03:00", sleepDuration: 4, dateString: "07/05/2023"),
//        SleepStat(weekOfYear: "\(Calendar.current.component(.weekOfYear, from: CustomDateFormatter.dateFormat.date(from: "22/04/2023") ?? Date()))", timeOfSleep: "03:00", wakeUpTime: "04:00", sleepDuration: 1, dateString: "22/04/2023"),
//        SleepStat(weekOfYear: "\(Calendar.current.component(.weekOfYear, from: CustomDateFormatter.dateFormat.date(from: "04/05/2023") ?? Date()))", timeOfSleep: "22:30", wakeUpTime: "08:00", sleepDuration: 9.5, dateString: "04/05/2023")]
    
    let weekOfYear = Calendar.current.component(.weekOfYear, from: Date(timeIntervalSinceNow: 0))
    
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
        // TODO: Pasos para extraer datos:
        // 1 - Leer datos de almacenamiento interno
        // 2 - Buscar datos de la semana actual
        // 3 - Almacenarlos de forma ordenada
        // 4 - Los huecos vacíos se muestran con valor "-" por defecto
        
//        struct User {
//            var firstName: Date
//        }
//
//        var users = [
//            User(firstName: CustomDateFormatter.dateFormat.date(from: "30/05/2023") ?? Date()),
//            User(firstName: CustomDateFormatter.dateFormat.date(from: "29/05/2023") ?? Date()),
//            User(firstName: CustomDateFormatter.dateFormat.date(from: "10/07/2023") ?? Date()),
//            User(firstName: CustomDateFormatter.dateFormat.date(from: "05/05/2023") ?? Date()),
//            User(firstName: CustomDateFormatter.dateFormat.date(from: "06/05/2023") ?? Date())
//        ]
//
//        print(DateFormatter().locale)
//        users.sort {
//            $0.firstName < $1.firstName
//        }
//
//        print(users)
        
//        for stat in sleepStatsDb {
//            if (weekOfYear == Int(stat.weekOfYear)) {
//
//            }
//        }
//        let statsOfWeek =
        
        presenter?.sleepStatsFetched(sleepStatsWeek)
    }
    
    func addSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {
        print("Interactor")
        let sleepDur = sleepDuration.replacingOccurrences(of: " hours", with: "")
        let weekOfYear = "\(Calendar.current.component(.weekOfYear, from: date))"
        let dateString = CustomDateFormatter.shared.formatDayMonth(date)
        
        print(sleepDur)
        if let sleepStatFoundIndex = sleepStatsDb.firstIndex(where: {$0.dateString == dateString}) {
            sleepStatsDb[sleepStatFoundIndex].weekOfYear = weekOfYear
            sleepStatsDb[sleepStatFoundIndex].date = date
            sleepStatsDb[sleepStatFoundIndex].dateString = dateString
            sleepStatsDb[sleepStatFoundIndex].timeOfSleep = CustomDateFormatter.shared.formatHourMinute(sleepTime)
            sleepStatsDb[sleepStatFoundIndex].wakeUpTime = CustomDateFormatter.shared.formatHourMinute(wakeUpTime)
            sleepStatsDb[sleepStatFoundIndex].sleepDuration = Double(sleepDur) ?? 0.0
            print(sleepStatsDb[sleepStatFoundIndex].sleepDuration)
        } else {
            sleepStatsDb.append(SleepStat(weekOfYear: weekOfYear, timeOfSleep: CustomDateFormatter.shared.formatHourMinute(sleepTime), wakeUpTime: CustomDateFormatter.shared.formatHourMinute(wakeUpTime), sleepDuration: Double(sleepDur) ?? 0.0, dateString: dateString , date: date))
        }
        
        //getSleepStatsFromWeek("\(Calendar.current.component(.weekOfYear, from: Date()))")
        getSleepStatsFromWeek("18")
        
        print("TOTAL:  \(sleepStatsDb)")
        print("WEEK:  \(sleepStatsWeek)")
        
        presenter?.sleepStatsFetched(sleepStatsWeek)
    }
    
    private func getSleepStatsFromWeek(_ weekOfYear: String) {
        sleepStatsWeek = sleepStatsDb.filter { $0.weekOfYear.contains(weekOfYear) }
        sleepStatsWeek.sort { $0.date < $1.date }
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

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

    var sleepStatsWeek = [SleepData]()
    var sleepStatsDb = [SleepData]()
   
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
        
        //addSleepStat(Date(), Date(), Date(), "8 hours")

        DataPersistence.shared.loadTitles { sleepData in
            sleepStatsDb = sleepData
            print(sleepStatsDb)
            getSleepStatsFromWeek("\(Calendar.current.component(.weekOfYear, from: Date()))")

            presenter?.sleepStatsFetched(sleepStatsWeek)
        }
    }
    
    func addSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {
        let sleepDur = sleepDuration.replacingOccurrences(of: " hours", with: "")
        let weekOfYear = "\(Calendar.current.component(.weekOfYear, from: date))"
        let dateString = CustomDateFormatter.shared.formatDayMonth(date)
        
        let sleepData = SleepData(context: DataPersistence.shared.context)
        sleepData.weekOfYear = weekOfYear
        sleepData.date = date
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
            getSleepStatsFromWeek("\(Calendar.current.component(.weekOfYear, from: Date()))")
            presenter?.sleepStatsFetched(sleepStatsWeek)
        }
    }
    
    private func getSleepStatsFromWeek(_ weekOfYear: String) {
        sleepStatsWeek = sleepStatsDb.filter { $0.weekOfYear!.contains(weekOfYear) }
        sleepStatsWeek.sort { $0.date! < $1.date! }
        print(sleepStatsWeek.count)
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

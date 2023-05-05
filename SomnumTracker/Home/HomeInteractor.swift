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

    var sleepStats = [SleepStat]()
    let weekOfYear = Calendar.current.component(.weekOfYear, from: Date(timeIntervalSinceNow: 0))
    
    func resetEntryValues() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat =  "HH:mm"
        if let sleepDate = dateFormatter.date(from: Constants.defaultSleepTime),
            let wakeUpDate = dateFormatter.date(from: Constants.defaultWakeUpTime){
            
            presenter?.entryValuesReset(sleepDate, wakeUpDate, Constants.sleepDurationText)
        }
    }
    
    func fetchSleepStats() {
        sleepStats = [
            SleepStat(weekOfYear: "/M", timeOfSleep: "01:00", wakeUpTime: "02:00", sleepDuration: 8, createAt:       CustomDateFormatter.dateFormatter.date(from: "20/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/T", timeOfSleep: "02:00", wakeUpTime: "03:00", sleepDuration: 7.5, createAt: CustomDateFormatter.dateFormatter.date(from: "21/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/W", timeOfSleep: "03:00", wakeUpTime: "04:00", sleepDuration: 9, createAt: CustomDateFormatter.dateFormatter.date(from: "22/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/TH", timeOfSleep: "10:50", wakeUpTime: "12:00", sleepDuration: 7, createAt: CustomDateFormatter.dateFormatter.date(from: "23/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/F", timeOfSleep: "12:45", wakeUpTime: "10:00", sleepDuration: 8.5, createAt: CustomDateFormatter.dateFormatter.date(from: "24/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/S", timeOfSleep: "07:30", wakeUpTime: "21:00", sleepDuration: 6, createAt: CustomDateFormatter.dateFormatter.date(from: "25/04/2023") ?? Date()),
            SleepStat(weekOfYear: "5/S", timeOfSleep: "20:25", wakeUpTime: "22:13", sleepDuration: 6.5, createAt: CustomDateFormatter.dateFormatter.date(from: "20/12/2023") ?? Date())]
        
        presenter?.sleepStatsFetched(sleepStats)
    }
    
//    private func resetValues() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat =  "MM/dd/yyyy"
//        let date = Date()
//
//        dateFormatter.dateFormat =  "HH:mm"
//        if let date = dateFormatter.date(from: Constants.defaultSleepTime) {
//            let timeOfSleepEntryDate = date
//        }
//        if let date = dateFormatter.date(from: Constants.defaultWakeUpTime) {
//            
//            wakeUpTimeEntryDate = date
//        }
//        sleepDurationValueLabel.text = Constants.defaultSleepDuration
//    }

}

extension HomeInteractor: HomeRemoteDataManagerOutputProtocol {
    // TODO: Implement use case methods
}

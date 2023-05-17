//
//  HomePresenter.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 3/5/23.
//  
//

import Foundation
import SwiftUI
import Combine

class HomePresenter  {
    // MARK: Properties
    var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var wireFrame: HomeWireFrameProtocol?
}

extension HomePresenter: HomePresenterProtocol {
    // TODO: implement presenter methods
    func viewDidLoad() {
        interactor?.fetchSleepStats()
    }

    func didClickEntryAlertView() {
        wireFrame?.addEntryAlert()
    }
    
    func didClickSubmitSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {
        wireFrame?.removeEntryAlert()
        interactor?.addSleepStat(date, sleepTime, wakeUpTime, sleepDuration)
    }
    
    func didClickResetValues() {
        interactor?.resetEntryValues()
    }
    
    func didClickCancelEntryAlert() {
        wireFrame?.removeEntryAlert()
    }
    
    func didEntryValuesChanged(_ sleepTime: Date, _ wakeUpTime: Date) {
        interactor?.updateSleepDurationFromEntryChanges(sleepTime: sleepTime, wakeUpTime: wakeUpTime)
    }
    
    func didClickNextWeek(weekOfYear: String, year: String) {
        interactor?.getNextWeek(weekOfYear: weekOfYear, year: year)
    }
    
    func didClickLastWeek(weekOfYear: String, year: String) {
        interactor?.getLastWeek(weekOfYear: weekOfYear, year: year)
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func entryValuesChanged(_ sleepDuration: String) {
        view?.showDurationFromEntryChanges(sleepDuration)
    }
    
    func entryValuesReset(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {
        view?.showResetEntryData(sleepTime, wakeUpTime, sleepDuration)
    }
    
    func sleepStatsFetched(_ sleepStats: [SleepData]) {
        view?.showSleepStats(sleepStats)
        view?.updateUI()
    }
}

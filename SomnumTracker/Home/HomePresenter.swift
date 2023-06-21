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
    var alertView: HomeAlertViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var wireFrame: HomeWireFrameProtocol?
}

// MARK: - Home presenter protocol
extension HomePresenter: HomePresenterProtocol {
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
    
    func didClickNextWeek(date: Date) {
        interactor?.getNextWeek(date: date)
    }
    
    func didClickLastWeek(date: Date) {
        interactor?.getLastWeek(date: date)
    }
    
    func showSettingsView() {
        wireFrame?.presentNewViewSettings(from: view!, presentationStyle: .popover)
    }
}

// MARK: - Home interactor output protocol
extension HomePresenter: HomeInteractorOutputProtocol {
    func entryValuesChanged(_ sleepDuration: String) {
        alertView?.showDurationFromEntryChanges(sleepDuration)
    }
    
    func entryValuesReset(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {
        alertView?.showResetEntryData(sleepTime, wakeUpTime, sleepDuration)
    }
    
    func sleepStatsFetched(_ sleepStats: [SleepStat]) {
        view?.showSleepStats(sleepStats)
        view?.updateUI()
    }
}

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
        //viewModel = HomeViewModel()
        interactor?.fetchSleepStats()
    }

    func didClickEntryAlertView() {
        wireFrame?.addEntryAlert()
    }
    
    func didClickSubmitSleepStat() {
        
    }
    
    func didClickResetValues() {
        interactor?.resetEntryValues()
    }
    
    func didClickCancelEntryAlert() {
        wireFrame?.removeEntryAlert()
    }
    
    func didEntryValuesChanged(sleepTime: Date, wakeUpTime: Date) {
        
    }
    
    func getSleepStats() {
        
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func entryValuesReset(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {
        view?.showResetEntryData(sleepTime, wakeUpTime, sleepDuration)
        
    }
    
    func sleepStatsFetched(_ sleepStats: [SleepStat]) {
        view?.showSleepStats(sleepStats)
        view?.updateUI()
    }
}

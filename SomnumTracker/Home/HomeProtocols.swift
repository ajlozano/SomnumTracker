//
//  HomeProtocols.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 3/5/23.
//  
//

import Foundation
import UIKit

protocol HomeViewProtocol: AnyObject {
    // PRESENTER -> VIEW
    var presenter: HomePresenterProtocol? { get set }
    
    // RELOAD TABLE VIEW, ACTIVITY INDICATOR, ETC
    func updateUI()
    func showSleepStats(_ sleepStats: [SleepData])
    func showResetEntryData(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
    func showDurationFromEntryChanges(_ sleepDuration: String)
}

protocol HomePresenterProtocol: AnyObject {
    // VIEW -> PRESENTER
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    var wireFrame: HomeWireFrameProtocol? { get set }
    
    func viewDidLoad()
    
    func didClickEntryAlertView()
    func didClickSubmitSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
    func didClickResetValues()
    func didClickCancelEntryAlert()
    func didEntryValuesChanged(_ sleepTime: Date, _ wakeUpTime: Date)
    func didClickNextWeek(weekOfYear: String, year: String)
    func didClickLastWeek(weekOfYear: String, year: String)
}
protocol HomeInteractorInputProtocol: AnyObject {
    // PRESENTER -> INTERACTOR
    var presenter: HomeInteractorOutputProtocol? { get set }
    var localDatamanager: HomeLocalDataManagerInputProtocol? { get set }
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol? { get set }
    
    func fetchSleepStats()
    func resetEntryValues()
    func updateSleepDurationFromEntryChanges(sleepTime: Date, wakeUpTime: Date)
    func addSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
    func getNextWeek(weekOfYear: String, year: String)
    func getLastWeek(weekOfYear: String, year: String)
}

protocol HomeInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    func sleepStatsFetched(_ sleepStats: [SleepData])
    func entryValuesReset(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
    func entryValuesChanged(_ sleepDuration: String)
}

protocol HomeWireFrameProtocol: AnyObject {
    // PRESENTER -> WIREFRAME
    var viewController: UIViewController? { get set }
    var presenter: HomePresenterProtocol? { get set }
    
    static func createHomeModule(on window: UIWindow)

    func addEntryAlert()
    func removeEntryAlert()
}

protocol HomeRemoteDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> REMOTEDATAMANAGER
    var remoteRequestHandler: HomeRemoteDataManagerOutputProtocol? { get set }
    
    // ADD FIREBASE DATA PETITIONS
}

protocol HomeRemoteDataManagerOutputProtocol: AnyObject {
    // REMOTEDATAMANAGER -> INTERACTOR
    
    // ADD FIREBASE DATA RECEPTION
}

protocol HomeLocalDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> LOCALDATAMANAGER
    // ADD DATA PERSISTENCE MANAGEMENT
}

protocol HomeDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> DATAMANAGER
    // USELESS AT THE MOMENT
}

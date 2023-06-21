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
    func showSleepStats(_ sleepStats: [SleepStat])
    //func showResetEntryData(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
    //func showDurationFromEntryChanges(_ sleepDuration: String)
}

protocol HomeAlertViewProtocol: AnyObject {
    // PRESENTER -> VIEW
    var presenter: HomePresenterProtocol? { get set }
    
    func showResetEntryData(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
    func showDurationFromEntryChanges(_ sleepDuration: String)
}

protocol HomePresenterProtocol: AnyObject {
    // VIEW -> PRESENTER
    var view: HomeViewProtocol? { get set }
    var alertView: HomeAlertViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    var wireFrame: HomeWireFrameProtocol? { get set }
    
    func viewDidLoad()
    func didClickEntryAlertView()
    func didClickSubmitSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
    func didClickResetValues()
    func didClickCancelEntryAlert()
    func didEntryValuesChanged(_ sleepTime: Date, _ wakeUpTime: Date)
    func didClickNextWeek(date: Date)
    func didClickLastWeek(date: Date)
    func showSettingsView()
}

protocol HomeInteractorInputProtocol: AnyObject {
    // PRESENTER -> INTERACTOR
    var presenter: HomeInteractorOutputProtocol? { get set }
    
    func fetchSleepStats()
    func resetEntryValues()
    func updateSleepDurationFromEntryChanges(sleepTime: Date, wakeUpTime: Date)
    func addSleepStat(_ date: Date, _ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
    func getNextWeek(date: Date)
    func getLastWeek(date: Date)
}

protocol HomeInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    func sleepStatsFetched(_ sleepStats: [SleepStat])
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
    func presentNewViewSettings(from view: HomeViewProtocol, presentationStyle: UIModalPresentationStyle)
}

protocol HomeWireframeFromOtherPresenterProtocol: AnyObject {
    // OTHER PRESENTER -> WIREFRAME
    var presenter: HomePresenterProtocol? { get set }
    
    func notifyFetchingSleepStats()
}



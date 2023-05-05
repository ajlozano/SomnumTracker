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
    func showResetEntryData(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
    func showDurationFromEntryChanges(_ sleepDuration: String)
}

protocol HomeWireFrameProtocol: AnyObject {
    // PRESENTER -> WIREFRAME
    var viewController: UIViewController? { get set }
    var presenter: HomePresenterProtocol? { get set }
    
    static func createHomeModule(on window: UIWindow)

    func addEntryAlert()
    func removeEntryAlert()

}

protocol HomePresenterProtocol: AnyObject {
    // VIEW -> PRESENTER
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    var wireFrame: HomeWireFrameProtocol? { get set }
    
    func viewDidLoad()
    
    func didClickEntryAlertView()
    func didClickSubmitSleepStat()
    func didClickResetValues()
    func didClickCancelEntryAlert()
    func didEntryValuesChanged(sleepTime: Date, wakeUpTime: Date)
    func getSleepStats()
}

protocol HomeInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    func sleepStatsFetched(_ sleepStats: [SleepStat])
    func entryValuesReset(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String)
}

protocol HomeInteractorInputProtocol: AnyObject {
    // PRESENTER -> INTERACTOR
    var presenter: HomeInteractorOutputProtocol? { get set }
    var localDatamanager: HomeLocalDataManagerInputProtocol? { get set }
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol? { get set }
    
    func fetchSleepStats()
    func resetEntryValues()
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

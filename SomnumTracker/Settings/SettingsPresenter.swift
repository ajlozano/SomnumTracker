//
//  SettingsPresenter.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//  
//

import Foundation

class SettingsPresenter  {
    
    // MARK: Properties
    weak var view: SettingsViewProtocol?
    var interactor: SettingsInteractorInputProtocol?
    var wireFrame: SettingsWireFrameProtocol?
    var previousWireframe: HomeWireframeFromOtherPresenterProtocol?
}

extension SettingsPresenter: SettingsPresenterProtocol {
    func didClickOnContact(contact: Contact) {
        interactor?.makeHyperLink(contact)
    }
    
    func deleteAllStats() {
        interactor?.deleteAllStats()
    }

    func viewDidLoad() {}
    
    func notifyFetchingStats() {
        previousWireframe?.notifyFetchingSleepStats()
    }
}

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    func statsDeleted() {
        view?.statsDeleted()
    }
}

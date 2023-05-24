//
//  SettingsInteractor.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//  
//

import Foundation

class SettingsInteractor: SettingsInteractorInputProtocol {
    // MARK: Properties
    weak var presenter: SettingsInteractorOutputProtocol?

    func deleteAllStats() {
        print("interactor")
        
        DataPersistence.shared.deleteAllData()
        presenter?.statsDeleted()
    }
}


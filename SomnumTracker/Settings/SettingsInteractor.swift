//
//  SettingsInteractor.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//  
//

import UIKit

class SettingsInteractor: SettingsInteractorInputProtocol {
    // MARK: Properties
    weak var presenter: SettingsInteractorOutputProtocol?

    func deleteAllStats() {
        DataPersistence.shared.deleteAllData()
        presenter?.statsDeleted()
    }
    
    func makeHyperLink(_ contact: Contact) {
        if let url = URL(string: contact.path) {
            UIApplication.shared.open(url)
        }
    }
}


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
    
}

extension SettingsPresenter: SettingsPresenterProtocol {
    // TODO: implement presenter methods
    func viewDidLoad() {
    }
}

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    // TODO: implement interactor output methods
}

//
//  SettingsWireFrame.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//  
//

import Foundation
import UIKit

class SettingsWireFrame: SettingsWireFrameProtocol {
    
    // MARK: - Properties
    static var settingsStoryboard: UIStoryboard {
        return UIStoryboard(name: "SettingsView", bundle: Bundle.main)
    }
    
    class func createSettingsModule(with previousWireframe: HomeWireframeFromOtherPresenterProtocol) -> UIViewController {
        let view = settingsStoryboard.instantiateViewController(withIdentifier: "settingsView")
        if let viewController = view as? SettingsView {
            let presenter: SettingsPresenterProtocol & SettingsInteractorOutputProtocol = SettingsPresenter()
            let interactor: SettingsInteractorInputProtocol = SettingsInteractor()
            let wireFrame: SettingsWireFrameProtocol = SettingsWireFrame()
            
            viewController.presenter = presenter
            presenter.view = viewController
            presenter.wireFrame = wireFrame
            presenter.previousWireframe = previousWireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            return viewController
        }
        return UIViewController()
    }
}

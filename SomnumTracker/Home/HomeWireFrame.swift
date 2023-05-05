//
//  HomeWireFrame.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 3/5/23.
//  
//

import Foundation
import UIKit


class HomeWireFrame: HomeWireFrameProtocol {
    weak var viewController: UIViewController?
    weak var presenter: HomePresenterProtocol?

    var alertView: HomeAlertView?
    
    
    static var homeStoryboard: UIStoryboard {
        return UIStoryboard(name: "HomeView", bundle: Bundle.main)
    }
    
    class func createHomeModule(on window: UIWindow) {
        let view = homeStoryboard.instantiateViewController(withIdentifier: "homeView")
        if let viewController = view as? HomeView {
            let presenter: HomePresenterProtocol & HomeInteractorOutputProtocol = HomePresenter()
            let interactor: HomeInteractorInputProtocol & HomeRemoteDataManagerOutputProtocol = HomeInteractor()
            let localDataManager: HomeLocalDataManagerInputProtocol = HomeLocalDataManager()
            let remoteDataManager: HomeRemoteDataManagerInputProtocol = HomeRemoteDataManager()
            let wireFrame: HomeWireFrameProtocol = HomeWireFrame()
            
            viewController.presenter = presenter
            presenter.view = viewController
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.localDatamanager = localDataManager
            interactor.remoteDatamanager = remoteDataManager
            remoteDataManager.remoteRequestHandler = interactor
            
            wireFrame.viewController = viewController
            wireFrame.presenter = presenter
            
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
        }
    }
    // TODO: CONTINUAR AÑADIENDO O NO ALERT EN WIREFRAME (LEER ARTICULO GUARDADO)
    func addEntryAlert() {
        if let view = viewController {
            HomeAlertView(on: view).showNewEntryAlert { alert in
                self.alertView = alert
                //let presenter: HomePresenterProtocol & HomeInteractorOutputProtocol = HomePresenter()
                self.alertView?.presenter = self.presenter
                self.presenter?.view = self.alertView
            }
        }
    }
    
    func removeEntryAlert() {
        if let alert = alertView {
            alert.removeAlertView()
            self.presenter?.view = self.viewController as! HomeView
        }
    }
}

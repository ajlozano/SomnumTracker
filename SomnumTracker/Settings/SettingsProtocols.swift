//
//  SettingsProtocols.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//  
//

import Foundation
import UIKit

protocol SettingsViewProtocol: AnyObject {
    // PRESENTER -> VIEW
    var presenter: SettingsPresenterProtocol? { get set }
    func statsDeleted()
}

protocol SettingsWireFrameProtocol: AnyObject {
    // PRESENTER -> WIREFRAME
    static func createSettingsModule(with previousWireframe: HomeWireframeFromOtherPresenterProtocol) -> UIViewController
}

protocol SettingsPresenterProtocol: AnyObject {
    // VIEW -> PRESENTER
    var view: SettingsViewProtocol? { get set }
    var interactor: SettingsInteractorInputProtocol? { get set }
    var wireFrame: SettingsWireFrameProtocol? { get set }
    var previousWireframe: HomeWireframeFromOtherPresenterProtocol? { get set }
    
    func viewDidLoad()
    func deleteAllStats()
    func notifyFetchingStats()
    func didClickOnContact(contact: Contact)
}

protocol SettingsInteractorInputProtocol: AnyObject {
    // PRESENTER -> INTERACTOR
    var presenter: SettingsInteractorOutputProtocol? { get set }
    func deleteAllStats()
    func makeHyperLink(_ contact: Contact)
}

protocol SettingsInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    func statsDeleted()
}






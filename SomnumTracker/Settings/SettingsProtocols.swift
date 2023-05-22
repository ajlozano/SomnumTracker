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
}

protocol SettingsWireFrameProtocol: AnyObject {
    // PRESENTER -> WIREFRAME
    static func createSettingsModule() -> UIViewController
}

protocol SettingsPresenterProtocol: AnyObject {
    // VIEW -> PRESENTER
    var view: SettingsViewProtocol? { get set }
    var interactor: SettingsInteractorInputProtocol? { get set }
    var wireFrame: SettingsWireFrameProtocol? { get set }
    
    func viewDidLoad()
}

protocol SettingsInteractorOutputProtocol: AnyObject {
// INTERACTOR -> PRESENTER
}

protocol SettingsInteractorInputProtocol: AnyObject {
    // PRESENTER -> INTERACTOR
    var presenter: SettingsInteractorOutputProtocol? { get set }
}





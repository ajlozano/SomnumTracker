//
//  SettingsView.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//  
//

import Foundation
import UIKit

class SettingsView: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var settingsTableView: UITableView!

    // MARK: Properties
    var presenter: SettingsPresenterProtocol?
    let contactsModel = [
        Contact(title: "Twitter", path: ""),
        Contact(title: "LinkedIn", path: "")]
    var settingsModel = [
        Setting(icon: UIImage(named: "Bell") ?? UIImage(), title: "Enable notifications", actionItem: UIView()),
        Setting(icon: UIImage(named: "trash") ?? UIImage(),title: "Delete Sleep stats", actionItem: UIView())]

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
}

extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == settingsTableView) {
            return settingsModel.count
        }
        
        return contactsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == settingsTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsViewCell
            //cell?.titleLabel.text = "testing setting cell"
            cell?.setup(icon: settingsModel[indexPath.row].icon,
                        title: settingsModel[indexPath.row].title,
                        action: settingsModel[indexPath.row].actionItem)
            
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as? ContactsViewCell
            cell?.setup(linkTitle: contactsModel[indexPath.row].title,
                        path: contactsModel[indexPath.row].path)
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == settingsTableView) {
            
        }
        else if(tableView == contactsTableView) {
            
        }
    }
}

extension SettingsView: SettingsViewProtocol {
    func updateUI() {
        DispatchQueue.main.async {
            self.settingsTableView.reloadData()
            self.contactsTableView.reloadData()
        }
    }
}

extension SettingsView {
    private func setUpView() {
        //contactsTableView.register(ContactsViewCell.self, forCellReuseIdentifier: "SettingsCell")
        settingsTableView.isScrollEnabled = false
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        //contactsTableView.register(SettingsViewCell.self, forCellReuseIdentifier: "ContactsCell")
        contactsTableView.isScrollEnabled = false
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
}



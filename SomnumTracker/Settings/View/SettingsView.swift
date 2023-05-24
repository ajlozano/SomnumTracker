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
    @IBOutlet weak var profileView: UIView!
    
    // MARK: Properties
    var presenter: SettingsPresenterProtocol?
    var contactsModel: [Contact] = [Contact]()
    var settingsModel: [Setting] = [Setting]()
    let deleteButton = UIButton()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func didClickDeleteButton(sender: UIButton) {
        showAlert(sender)
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
            tableView.allowsSelection = false
            cell?.setup(icon: settingsModel[indexPath.row].icon,
                        title: settingsModel[indexPath.row].title,
                        timeView: settingsModel[indexPath.row].pickerItem,
                        action: settingsModel[indexPath.row].actionItem,
                        screenWidth: self.view.frame.width)
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == settingsTableView) {
            return tableView.frame.height / CGFloat(settingsModel.count)
        }
        else {
            return tableView.frame.height / CGFloat(contactsModel.count)
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
    
    func statsDeleted() {
        deleteButton.isEnabled = false
        
    }
}

extension SettingsView {
    private func setUpView() {
        settingsTableView.isScrollEnabled = false
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.layer.cornerRadius = 10
        
        contactsTableView.isScrollEnabled = false
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.layer.cornerRadius = 10
        profileView.layer.cornerRadius = 10

        let notifyIcon = UIImage(systemName: "bell", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        let deleteIcon = UIImage(systemName: "exclamationmark.triangle", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        let notifyAction = UISwitch()
        deleteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        let trashImage = UIImage(systemName: "trash",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        deleteButton.setImage(trashImage, for: .normal)
        deleteButton.tintColor = .white
        
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.layer.cornerRadius = 10
        deleteButton.addTarget(self, action: #selector(didClickDeleteButton(sender:)), for: .touchUpInside)
    
        // Date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        //datePicker.addTarget(self, action: #selector(didDateChanged), for: UIControl.Event.valueChanged)
        datePicker.maximumDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        if let date = dateFormatter.date(from: "09:00") {
            datePicker.date = date
        }
        datePicker.frame = CGRect(x: 0, y: 0, width: 85, height: 30)
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .clear
        
        settingsModel = [
            Setting(icon: deleteIcon ?? UIImage(), title: "Delete sleep stats", pickerItem: nil ,actionItem: deleteButton),
            Setting(icon: notifyIcon ?? UIImage(), title: "Notifications", pickerItem: datePicker, actionItem: notifyAction)]
        
        contactsModel = [
            Contact(title: "📱 Twitter", path: ""),
            Contact(title: "🧑‍💻 LinkedIn", path: "")]
    }
    
    private func showAlert(_ sender: UIButton) {
        // Create new Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete all stats?", preferredStyle: .alert)
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in
            sender.backgroundColor = .systemGreen
            //sender.isEnabled = false
            self.presenter?.deleteAllStats()
            self.presenter?.notifyFetchingStats()
         })
        // Create CANCEL button with action handler
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        //Add CANCEL button to a dialog message
        dialogMessage.addAction(cancel)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
}



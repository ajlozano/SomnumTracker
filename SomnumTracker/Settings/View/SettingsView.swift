//
//  SettingsView.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//  
//

import Foundation
import UIKit
import UserNotifications

class SettingsView: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    
    // MARK: Properties
    var presenter: SettingsPresenterProtocol?
    var contactsModel: [Contact] = [Contact]()
    var settingsModel: [Setting] = [Setting]()
    let deleteButton = UIButton()
    let notificationSwitch = UISwitch()
    let timeNotificationPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.accessibilityIdentifier = "timeNotificationPicker"
        return datePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {}
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfNotificationEnabled()
    
    }
    
    @objc func didClickDeleteButton(sender: UIButton) {
        showAlert(sender)
    }
    
    @objc func didEnableNotification(sender: UISwitch) {
        if(sender.isOn) {
            checkForNotificationPermission(time: timeNotificationPicker.date)
        } else {
            disableNotifications()
        }
    }
    
    @objc func didDateChanged() {
        if (notificationSwitch.isOn) {
            dispatchNotification(time: timeNotificationPicker.date)
        }
    }
}


// MARK: - Table view data source and delegate
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
        if(tableView == contactsTableView) {
            presenter?.didClickOnContact(contact: contactsModel[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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

// MARK: - Settings view protocol
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

// MARK: - view setup
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
        
        let deleteIcon = UIImage(systemName: "exclamationmark.triangle", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        let trashImage = UIImage(systemName: "trash",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        deleteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        deleteButton.setImage(trashImage, for: .normal)
        deleteButton.tintColor = .white
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.layer.cornerRadius = 10
        deleteButton.addTarget(self, action: #selector(didClickDeleteButton(sender:)), for: .touchUpInside)
    
        let notifyIcon = UIImage(systemName: "bell", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        notificationSwitch.addTarget(self, action: #selector(didEnableNotification(sender:)), for: .touchUpInside)
        // Date picker
        timeNotificationPicker.datePickerMode = .time
        timeNotificationPicker.preferredDatePickerStyle = .compact
        timeNotificationPicker.addTarget(self, action: #selector(didDateChanged), for: UIControl.Event.valueChanged)
        timeNotificationPicker.maximumDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        if let date = dateFormatter.date(from: "10:00") {
            timeNotificationPicker.date = date
        }
        timeNotificationPicker.frame = CGRect(x: 0, y: 0, width: 85, height: 30)
        timeNotificationPicker.preferredDatePickerStyle = .compact
        timeNotificationPicker.backgroundColor = .clear
        
        settingsModel = [
            Setting(icon: deleteIcon ?? UIImage(), title: "Delete sleep stats", pickerItem: nil ,actionItem: deleteButton),
            Setting(icon: notifyIcon ?? UIImage(), title: "Notifications", pickerItem: timeNotificationPicker, actionItem: notificationSwitch)]
        
        contactsModel = [
            Contact(title: Constants.twitterTitle, path: Constants.twitterPath),
            Contact(title: Constants.linkedinTitle, path: Constants.linkedinPath)]
    }
}

// MARK: - Alert setup
extension SettingsView {
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
            //print("Ok button tapped")
         })
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        //Add CANCEL button to a dialog message
        dialogMessage.addAction(cancel)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    private func checkForNotificationPermission(time: Date) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .denied:
                return
            case .authorized:
                self.dispatchNotification(time: time)
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.sound, .alert]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification(time: time)
                    }
                }
            default:
                return
            }
        }
    }
    
    private func dispatchNotification(time: Date) {
        let identifier = Constants.notificationIdentifier
        let title = Constants.notificationTitle
        let body = Constants.notificationBody
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let calendar = Calendar.current
        let timeComponent = Calendar.current.dateComponents([.hour, .minute], from: time)
        var dateComponent = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponent.hour = timeComponent.hour
        dateComponent.minute = timeComponent.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    
    private func disableNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    private func checkIfNotificationEnabled() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { notifications in
            if notifications.count != 0 {
                var dateComponent = DateComponents()
                var date : Date?
                for request in notifications {
                    let trigger = request.trigger as! UNCalendarNotificationTrigger

                    dateComponent.hour = trigger.dateComponents.hour
                    dateComponent.minute = trigger.dateComponents.minute
                    date = Calendar.current.date(from: dateComponent)
                }
                
                DispatchQueue.main.async {
                    self.notificationSwitch.setOn(true, animated: true)
                    self.timeNotificationPicker.date = date!
                }
            }
        }
    }
}


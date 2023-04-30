//
//  SleepEntryAlert.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 28/4/23.
//

import UIKit
import DropDown

class SleepEntryAlert {
    
    struct Constants {
        static let titleText = "New Sleep Entry"
        static let dateText = "Date:"
        static let timeOfSleepText = "Time of sleep:"
        static let wakeUpTimeText = "Wake up time:"
        static let sleepDurationText = "Sleep duration: "
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.6
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    func showNewEntryAlert(on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width-80, height: 300)
        
        createAlertAttributes(on: alertView)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = 0.6
        }) { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertView.center = targetView.center
                })
            }
        }
    }
    
    @objc func dismissAlert() {
        
    }
    
    func createAlertAttributes(on view: UIView) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        // Text labels
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        titleLabel.text = Constants.titleText
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        view.addSubview(titleLabel)
        
        // Date View
        let dateView = UIView(frame: CGRect(x: 60, y: 70, width: view.frame.size.width, height: 25))
        view.addSubview(dateView)
        // Date Label
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        dateLabel.text = Constants.dateText
        dateLabel.textAlignment = .left
        dateView.addSubview(dateLabel)
        // Date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.maximumDate = Date()
        datePicker.frame = CGRect(x: view.frame.size.width - 220, y: 0, width: 80, height: 25)
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .clear
        dateView.addSubview(datePicker)
        
        // Time of sleep View
        let timeOfSleepView = UIView(frame: CGRect(x: 60, y: 100, width: view.frame.size.width, height: 25))
        view.addSubview(timeOfSleepView)
        // Time of sleep label
        let timeOfSleepLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        timeOfSleepLabel.text = Constants.timeOfSleepText
        timeOfSleepLabel.textAlignment = .left
        timeOfSleepView.addSubview(timeOfSleepLabel)
        // Tame of sleep picker
        let timeOfSleepPicker = UIDatePicker()
        timeOfSleepPicker.datePickerMode = .time
        timeOfSleepPicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        timeOfSleepPicker.maximumDate = Date()
        if let date = dateFormatter.date(from: "23:00") {
            timeOfSleepPicker.date = date
        }
        timeOfSleepPicker.frame = CGRect(x: view.frame.size.width - 220, y: 0, width: 95, height: 25)
        timeOfSleepPicker.preferredDatePickerStyle = .compact
        timeOfSleepPicker.backgroundColor = .clear
        timeOfSleepView.addSubview(timeOfSleepPicker)
        
        // Time of sleep View
        let wakeUpView = UIView(frame: CGRect(x: 60, y: 130, width: view.frame.size.width, height: 25))
        view.addSubview(wakeUpView)
        // Wake Up label
        let wakeUpTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        wakeUpTimeLabel.text = Constants.wakeUpTimeText
        wakeUpTimeLabel.textAlignment = .left
        wakeUpView.addSubview(wakeUpTimeLabel)
        // Wake Up picker
        let wakeUpPicker = UIDatePicker()
        wakeUpPicker.datePickerMode = .time
        wakeUpPicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        wakeUpPicker.maximumDate = Date()
        if let date = dateFormatter.date(from: "07:30") {
            wakeUpPicker.date = date
        }
        wakeUpPicker.frame = CGRect(x: view.frame.size.width - 220, y: 0, width: 95, height: 25)
        wakeUpPicker.preferredDatePickerStyle = .compact
        wakeUpPicker.backgroundColor = .clear
        wakeUpView.addSubview(wakeUpPicker)
        
        // Separator line
        let separatorView = UIView(frame: CGRect(x: 40, y: 170, width: view.frame.size.width-80, height: 1))
        separatorView.backgroundColor = .black
        view.addSubview(separatorView)
        
        // sleep duration View
        let sleepDurationView = UIView(frame: CGRect(x: 60, y: 180, width: view.frame.size.width, height: 25))
        view.addSubview(sleepDurationView)
        // sleep duration Label
        let sleepDurationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        sleepDurationLabel.text = Constants.sleepDurationText
        sleepDurationLabel.textAlignment = .left
        sleepDurationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        sleepDurationView.addSubview(sleepDurationLabel)
        // sleep duration Label
        let sleepValueLabel = UILabel(frame: CGRect(x: view.frame.size.width - 185, y: 0, width: view.frame.size.width, height: 25))
        sleepValueLabel.text = "8.5 hours"
        sleepValueLabel.textAlignment = .left
        sleepValueLabel.font = UIFont.boldSystemFont(ofSize: 18)
        sleepDurationView.addSubview(sleepValueLabel)
        
        // Action Buttons View
        let actionButtonsView = UIView(frame: CGRect(x: 0, y: view.frame.height - 70, width: view.frame.size.width, height: 30))
        view.addSubview(actionButtonsView)
        // Reset Button
        let resetButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        resetButton.center.x = view.center.x - resetButton.frame.width/2
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.backgroundColor = .customBlueLight
        resetButton.layer.cornerRadius = 12
        actionButtonsView.addSubview(resetButton)
        // Cancel Button
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        cancelButton.center.x = resetButton.center.x - resetButton.frame.width * 1.2
        cancelButton.backgroundColor = .customBlueLight
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.layer.cornerRadius = 12
        actionButtonsView.addSubview(cancelButton)

        // Reset Button
        let submitButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/4, height: 30))
        submitButton.center.x = resetButton.center.x + resetButton.frame.width * 1.2
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .highlighted)
        submitButton.backgroundColor = .customBlue
        submitButton.layer.cornerRadius = 12
        submitButton.addTarget(actionButtonsView.self, action: #selector(submit), for: .touchUpInside)
        actionButtonsView.addSubview(submitButton)
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        
    }
    
    @objc func submit(sender: UIButton!) {
        print("TOUCHED")
    }
}

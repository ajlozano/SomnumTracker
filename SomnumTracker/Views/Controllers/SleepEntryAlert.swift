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
        
        let button = UIButton(frame: CGRect(x: 0, y: alertView.frame.size.height-50, width: alertView.frame.size.width, height: 50))
        alertView.addSubview(button)
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
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
        // Text labels
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        titleLabel.text = Constants.titleText
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        view.addSubview(titleLabel)
        
        let dateLabel = UILabel(frame: CGRect(x: 60, y: 70, width: view.frame.size.width, height: 20))
        dateLabel.text = Constants.dateText
        dateLabel.textAlignment = .left
        view.addSubview(dateLabel)
        
        let timeOfSleepLabel = UILabel(frame: CGRect(x: 60, y: 100, width: view.frame.size.width, height: 20))
        timeOfSleepLabel.text = Constants.timeOfSleepText
        timeOfSleepLabel.textAlignment = .left
        view.addSubview(timeOfSleepLabel)
        
        let wakeUpTimeLabel = UILabel(frame: CGRect(x: 60, y: 130, width: view.frame.size.width, height: 20))
        wakeUpTimeLabel.text = Constants.wakeUpTimeText
        wakeUpTimeLabel.textAlignment = .left
        view.addSubview(wakeUpTimeLabel)
        
        let sleepDurationLabel = UILabel(frame: CGRect(x: 60, y: 171, width: view.frame.size.width, height: 20))
        sleepDurationLabel.text = Constants.sleepDurationText
        sleepDurationLabel.textAlignment = .left
        sleepDurationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(sleepDurationLabel)
        
        // Separator line
        let separatorView = UIView(frame: CGRect(x: 40, y: 160, width: view.frame.size.width-80, height: 1))
        separatorView.backgroundColor = .black
        view.addSubview(separatorView)
        
        // Date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.maximumDate = Date()
        datePicker.frame = CGRect(x: 180, y: 65, width: 90, height: 25)
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .clear
        view.addSubview(datePicker)
        
        // Date picker
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        timePicker.maximumDate = Date()
        timePicker.frame = CGRect(x: 180, y: 95, width: 85, height: 25)
        timePicker.preferredDatePickerStyle = .compact
        timePicker.backgroundColor = .clear
        view.addSubview(timePicker)
        
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        
    }
}

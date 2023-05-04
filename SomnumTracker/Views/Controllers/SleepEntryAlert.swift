//
//  SleepEntryAlert.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 28/4/23.
//

import UIKit
import DropDown

class SleepEntryAlert {
    
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
    
    var targetView: UIView
    var dateEntry = UIDatePicker()
    var timeOfSleepEntry = UIDatePicker()
    var wakeUpTimeEntry = UIDatePicker()
    var sleepDurationValueLabel = UILabel()
    
    init(on viewController: UIViewController) {
        guard let view = viewController.view else {
            fatalError("Error setting view in Sleep entry Alert")
        }
        targetView = view
        return
    }
    
    func showNewEntryAlert() {
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width-80, height: 300)
        
        createAlertAttributes()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = 0.6
        }) { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertView.center = self.targetView.center
                })
            }
        }
    }
    
    private func createAlertAttributes() {
        // Ttitle label
        createTextLabel(on: alertView, on: nil, x: 0, y: 0, title: Constants.titleText, aligment: .center, widthLabel: alertView.frame.size.width, heightLabel: alertView.frame.height - 220, textSize: 25, isBold: true)
        
        // Date entries
        createDateEntry(on: alertView, on: dateEntry, x: 60, y: 70, title: Constants.dateText, dateMode: .date, dateModeWidth: 80, dateTime: "")
        createDateEntry(on: alertView, on: timeOfSleepEntry, x: 60, y: 100, title: Constants.timeOfSleepText, dateMode: .time, dateModeWidth: 95, dateTime: Constants.defaultSleepTime)
        createDateEntry(on: alertView, on: wakeUpTimeEntry, x: 60, y: 130, title: Constants.wakeUpTimeText, dateMode: .time, dateModeWidth: 95, dateTime: Constants.defaultWakeUpTime)
        
        // Separator line
        let separatorView = UIView(frame: CGRect(x: 40, y: 170, width: alertView.frame.width-80, height: 1))
        separatorView.backgroundColor = .black
        alertView.addSubview(separatorView)

        // sleep duration View
        let sleepDurationView = UIView(frame: CGRect(x: 45, y: 180, width: alertView.frame.width, height: alertView.frame.height - 275))
        alertView.addSubview(sleepDurationView)
        // Sleep duration labels
        createTextLabel(on: sleepDurationView, on: nil, x: 0, y: 0, title: Constants.sleepDurationText, aligment: .left, widthLabel: sleepDurationView.frame.size.width, heightLabel: sleepDurationView.frame.height, textSize: 20, isBold: true)
        createTextLabel(on: sleepDurationView, on: sleepDurationValueLabel, x: alertView.frame.size.width - 185, y: 0, title: Constants.defaultSleepDuration, aligment: .left, widthLabel: sleepDurationView.frame.size.width, heightLabel: sleepDurationView.frame.height, textSize: 18, isBold: true)
        
        // Action Buttons View
        let actionButtonsView = UIView(frame: CGRect(x: 0, y: alertView.frame.height - 70, width: alertView.frame.size.width, height: alertView.frame.height - 270))
        alertView.addSubview(actionButtonsView)
        // Button width is the same for all buttons.
        let buttonWidth = actionButtonsView.frame.size.width/4
        // Action buttons
        createButton(on: actionButtonsView,
                     x: alertView.center.x - buttonWidth/2,
                     width: buttonWidth,
                     title: "Reset",
                     backgroundColor: .customBlueLight,
                     titleColor: .black)
        createButton(on: actionButtonsView,
                     x: alertView.frame.size.width/3 - buttonWidth/2,
                     width: buttonWidth,
                     title: "Cancel",
                     backgroundColor: .customBlueLight,
                     titleColor: .black)
        createButton(on: actionButtonsView,
                     x: alertView.frame.size.width/3 * 2 + buttonWidth/2,
                     width: buttonWidth,
                     title: "Submit",
                     backgroundColor: .customBlue,
                     titleColor: .white)
    }
    
    private func createDateEntry(on view: UIView, on picker: UIDatePicker, x: CGFloat, y: CGFloat, title: String, dateMode: UIDatePicker.Mode, dateModeWidth: CGFloat, dateTime: String) {
        // Date View
        let dateView = UIView(frame: CGRect(x: x, y: y, width: view.frame.size.width, height: view.frame.height - 275))
        view.addSubview(dateView)
        // Date Label
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        dateLabel.text = title
        dateLabel.textAlignment = .left
        dateView.addSubview(dateLabel)
        // Date picker
        let datePicker = picker
        datePicker.datePickerMode = dateMode
        datePicker.addTarget(self, action: #selector(dateChanged), for: UIControl.Event.valueChanged)
        datePicker.maximumDate = Date()
        if dateMode == .time {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            if let date = dateFormatter.date(from: dateTime) {
                datePicker.date = date
                print(datePicker.date)
            }
        }

        datePicker.frame = CGRect(x: view.frame.width - 220, y: 0, width: dateModeWidth, height: 25)
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .clear
        dateView.addSubview(datePicker)
    }
    
    private func createButton(on view: UIView, x: CGFloat, width: CGFloat, title: String, backgroundColor: UIColor, titleColor: UIColor) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: view.frame.height))
        button.center.x = x
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(sleepEntryAction), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func createTextLabel(on view: UIView, on label: UILabel?, x: CGFloat, y: CGFloat, title: String, aligment: NSTextAlignment, widthLabel: CGFloat, heightLabel: CGFloat, textSize: CGFloat, isBold: Bool) {
        var titleLabel = label
        if label == nil {
            titleLabel = UILabel()
        }
        titleLabel!.frame = CGRect(x: x, y: y, width: widthLabel, height: heightLabel)
        titleLabel!.text = title
        titleLabel!.textAlignment = aligment
        if (isBold) {
            titleLabel!.font = UIFont.boldSystemFont(ofSize: textSize)
        }

        view.addSubview(titleLabel!)
    }
    
    private func computeTimeInHours(recent: Date, previous: Date) -> String {
        var delta = recent.timeIntervalSince(previous) / 3600
        if delta < 0 {
            delta += 24.0
        }
        return String(format: "%.2f", delta)
    }
    
    private func resetValues() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "MM/dd/yyyy"
        dateEntry.date = Date()

        dateFormatter.dateFormat =  "HH:mm"
        if let date = dateFormatter.date(from: Constants.defaultSleepTime) {
            timeOfSleepEntry.date = date
        }
        if let date = dateFormatter.date(from: Constants.defaultWakeUpTime) {
            print("other")
            wakeUpTimeEntry.date = date
        }
        sleepDurationValueLabel.text = Constants.defaultSleepDuration
    }
    
    @objc func dateChanged() {
        sleepDurationValueLabel.text = "\(computeTimeInHours(recent: wakeUpTimeEntry.date, previous: timeOfSleepEntry.date)) hours"
        print("Substraction: \(computeTimeInHours(recent: wakeUpTimeEntry.date, previous: timeOfSleepEntry.date))")
    }
    
    @objc func sleepEntryAction(sender: UIButton) {
        if (sender.titleLabel?.text == "Reset") {
            resetValues()
        } else if (sender.titleLabel?.text == "Cancel") || (sender.titleLabel?.text == "Submit") {
            UIView.animate(withDuration: 0.25,
                           animations: {
                self.alertView.frame = CGRect(x: 40,
                                              y: self.targetView.frame.size.height,
                                              width: self.targetView.frame.size.width-80,
                                              height: 300)
            }, completion: { done in
                if done {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.backgroundView.alpha = 0
                    }) { done in
                        if done {
                            self.alertView.removeFromSuperview()
                            self.backgroundView.removeFromSuperview()
                        }
                    }
                }
            })
        } else {
            print("error")
        }
    }
}

//
//  SleepStatsViewCell.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 20/4/23.
//

import UIKit

class HomeViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var sleepDurationLabel: UILabel!
    @IBOutlet weak var wakeupTimeLabel: UILabel!
    @IBOutlet weak var timeOfSleepLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.backgroundColor = UIColor.clear
        timeOfSleepLabel.font = timeOfSleepLabel.font.withSize(9)
        timeOfSleepLabel.textColor = .darkGray
        wakeupTimeLabel.font = wakeupTimeLabel.font.withSize(9)
        wakeupTimeLabel.textColor = .darkGray
        sleepDurationLabel.font = sleepDurationLabel.font.withSize(9)
        sleepDurationLabel.textColor = .darkGray
        weekdayLabel.font = weekdayLabel.font.withSize(7)
        weekdayLabel.textColor = .darkGray
    }
    
    func setup(timeOfSleep: String, wakeupTIme: String, sleepDuration: Double, weekday: String){
        timeOfSleepLabel.text = timeOfSleep
        wakeupTimeLabel.text = wakeupTIme
        sleepDurationLabel.text = "\(sleepDuration) h"
        weekdayLabel.text = weekday
    }
}

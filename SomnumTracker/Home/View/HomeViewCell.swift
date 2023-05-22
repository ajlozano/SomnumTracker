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
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.backgroundColor = .clear
        timeOfSleepLabel.font = timeOfSleepLabel.font.withSize(11)
        timeOfSleepLabel.textColor = .darkGray
        wakeupTimeLabel.font = wakeupTimeLabel.font.withSize(11)
        wakeupTimeLabel.textColor = .darkGray
        sleepDurationLabel.font = sleepDurationLabel.font.withSize(11)
        sleepDurationLabel.textColor = .darkGray
        dateLabel.font = dateLabel.font.withSize(10)
        dateLabel.textColor = .darkGray
    }
    
    func setup(timeOfSleep: String, wakeupTIme: String, sleepDuration: Double, weekday: String){
        timeOfSleepLabel.text = timeOfSleep
        wakeupTimeLabel.text = wakeupTIme
        sleepDurationLabel.text = "\(sleepDuration) h"
        dateLabel.text = weekday
    }
}

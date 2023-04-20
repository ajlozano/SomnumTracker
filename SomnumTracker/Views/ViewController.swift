//
//  ViewController.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 19/4/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var sleepStatsTableView: UITableView!
    @IBOutlet weak var sleepStatsDataView: UIView!
    @IBOutlet weak var sleepEntryButton: UIButton!
    @IBOutlet weak var sleepDurationView: UIView!
    @IBOutlet weak var sleepStatsView: UIView!
    
    let sleepStats = [SleepStats(timeOfSleep: "01:00", wakeupTime: "02:00", sleepDuration: "1 HRS"),
                                SleepStats(timeOfSleep: "02:00", wakeupTime: "03:00", sleepDuration: "2 HRS"),
                                SleepStats(timeOfSleep: "03:00", wakeupTime: "04:00", sleepDuration: "3 HRS"),
                                SleepStats(timeOfSleep: "10:50", wakeupTime: "12:00", sleepDuration: "15 HRS"),
                                SleepStats(timeOfSleep: "12:45", wakeupTime: "10:00", sleepDuration: "20 HRS"),
                                SleepStats(timeOfSleep: "07:30", wakeupTime: "21:00", sleepDuration: "2 HRS"),
                                SleepStats(timeOfSleep: "20:25", wakeupTime: "22:13", sleepDuration: "21 HRS")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .customLight
        //view.backgroundColor = .brown
        sleepStatsView.layer.cornerRadius = 15
        sleepStatsView.layer.shadowColor = UIColor.black.cgColor
        sleepStatsView.layer.shadowOpacity = 0.8
        sleepStatsView.layer.shadowOffset = CGSize(width: 2, height: 2)
        sleepStatsDataView.backgroundColor = .customLight
        sleepStatsDataView.layer.cornerRadius = 10
        
        sleepDurationView.layer.cornerRadius = 15
        sleepDurationView.layer.shadowColor = UIColor.black.cgColor
        sleepDurationView.layer.shadowOpacity = 0.8
        sleepDurationView.layer.shadowOffset = CGSize(width: 2, height: 2)
        sleepEntryButton.tintColor = .customBlue

        sleepEntryButton.titleLabel?.isHidden = true
        
        sleepStatsTableView.dataSource = self
        sleepStatsTableView.separatorColor = UIColor.clear
        sleepStatsTableView.isScrollEnabled = false
        sleepStatsTableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sleepStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleepStatsCell") as! SleepStatsViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.frame.size = CGSize(width: cell.frame.width, height: 50)
        
        
        
        cell.setup(timeOfSleep: sleepStats[indexPath.row].timeOfSleep, wakeupTIme: sleepStats[indexPath.row].wakeupTime, sleepDuration: sleepStats[indexPath.row].sleepDuration)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7
        
    }
    
}


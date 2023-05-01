//
//  ViewController.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 19/4/23.
//

import UIKit
import Foundation
import SwiftUI

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var sleepDurationSubview: UIView!
    @IBOutlet weak var sleepStatsTableView: UITableView!
    @IBOutlet weak var sleepStatsDataView: UIView!
    @IBOutlet weak var sleepEntryButton: UIButton!
    @IBOutlet weak var sleepDurationView: UIView!
    @IBOutlet weak var sleepStatsView: UIView!
    
    private let homeViewModel = HomeViewModel()
    
    var sleepEntryAlert: SleepEntryAlert?
    
    //let sleepStatsHistory = SleepStatsHistory()
    var statList: [SleepStats] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleepEntryAlert = SleepEntryAlert(on: self)
        
        setupView()
        setupBinders()
        homeViewModel.getSleepStatList()
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
        sleepEntryAlert!.showNewEntryAlert()
    }
    
    @objc func sleepEntryAction(sender: UIButton) {
        sleepEntryAlert!.sleepEntryAction(sender: sender)
    }
    
    func setupBinders() {
        homeViewModel.sleepStatList.bind { list in
            guard let statList = list else {
                print("Not found data in sleepStatList")
                return
            }
            self.statList = statList
        }
    }
    
    private func setupView() {
        view.backgroundColor = .customLight
        
        // Sleep Stats table configuration
        sleepStatsView.layer.cornerRadius = 15
        sleepStatsView.layer.shadowColor = UIColor.black.cgColor
        sleepStatsView.layer.shadowOpacity = 0.8
        sleepStatsView.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        sleepStatsDataView.backgroundColor = .customBlueLight
        sleepStatsDataView.layer.cornerRadius = 10
        
        sleepStatsTableView.dataSource = self
        sleepStatsTableView.separatorColor = UIColor.clear
        sleepStatsTableView.isScrollEnabled = false
        sleepStatsTableView.delegate = self
        
        sleepDurationView.layer.cornerRadius = 15
        sleepDurationView.layer.shadowColor = UIColor.black.cgColor
        sleepDurationView.layer.shadowOpacity = 0.8
        sleepDurationView.layer.shadowOffset = CGSize(width: 2, height: 2)
        sleepEntryButton.tintColor = .customBlue
        
        sleepEntryButton.titleLabel?.isHidden = true
        
        // Sleep duration graph view configuration
        let controller = UIHostingController(rootView: SleepStatsHistory())
        guard let sleepDurationGraphView = controller.view else {
            print("Graph view not found")
            return
        }
        
        //let newView = UIView()
        sleepDurationView.addSubview(sleepDurationGraphView)
        
        sleepDurationGraphView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sleepDurationView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sleepDurationView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 10)
        let widthConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 220)
        let heightConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 170)
        sleepDurationView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleepStatsCell") as! SleepStatsViewCell
        cell.backgroundColor = UIColor.clear
        //cell.frame.size = CGSize(width: cell.frame.width, height: 50)
        cell.setup(timeOfSleep: statList[indexPath.row].timeOfSleep,
                   wakeupTIme: statList[indexPath.row].wakeupTime,
                   sleepDuration: statList[indexPath.row].sleepDuration,
                   weekday: statList[indexPath.row].weekDay)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7
    }
}


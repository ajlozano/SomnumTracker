//
//  ViewController.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 19/4/23.
//

import UIKit
import Foundation
import SwiftUI
import Charts

class HomeView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var sleepDurationView: UIView!
    @IBOutlet weak var sleepDurationSubview: UIView!
    @IBOutlet weak var sleepStatsTableView: UITableView!
    @IBOutlet weak var sleepStatsDataView: UIView!
    @IBOutlet weak var sleepEntryButton: UIButton!
    @IBOutlet weak var sleepStatsView: UIView!
    
    @ObservedObject var viewModel = HomeViewModel()
    
    private var sleepEntryAlert: SleepEntryAlert?
    
    // MARK: Properties
    var presenter: HomePresenterProtocol?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleepEntryAlert = SleepEntryAlert(on: self)
        
        setupView()
        sleepStatsTableView.dataSource = self
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
        sleepEntryAlert!.showNewEntryAlert()
        //viewModel.addSleepStat(sleepStat: viewModel.sleepStats[0])
        viewModel.getSleepStatList()
 
    }
    
    @objc func sleepEntryAction(sender: UIButton) {
        sleepEntryAlert!.sleepEntryAction(sender: sender)
    }

    private func reloadTableView() {
        DispatchQueue.main.async {
            self.sleepStatsTableView.reloadData()
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
        let controller = UIHostingController(rootView: body)
        guard let sleepDurationGraphView = controller.view else {
            print("Graph view not found")
            return
        }
        
        sleepDurationView.addSubview(sleepDurationGraphView)
        
        // Add constraints
        sleepDurationGraphView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sleepDurationView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sleepDurationView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 10)
        let widthConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 220)
        let heightConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 170)
        sleepDurationView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sleepStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleepStatsCell") as! SleepStatsViewCell
        cell.backgroundColor = UIColor.clear
        
        // Week of year if we want to modify it in table view.
        //let weekOfYear = Calendar.current.component(.weekOfYear, from: statList[indexPath.row].createAt)
        
        cell.setup(timeOfSleep: viewModel.sleepStats[indexPath.row].timeOfSleep,
                   wakeupTIme: viewModel.sleepStats[indexPath.row].wakeupTime,
                   sleepDuration: viewModel.sleepStats[indexPath.row].sleepDuration,
                   weekday: CustomDateFormatter.shared.formatDayMonth(viewModel.sleepStats[indexPath.row].createAt))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7
    }
 
    // SwiftUI Chart view
    var body: some View {
        // TODO: Fix use of homeViewModel.list as MVVM
        Chart(viewModel.sleepStats) { sleepStat in
            AreaMark(
                x: .value("Weekday", CustomDateFormatter.shared.formatDayMonth(sleepStat.createAt)),
                y: .value("Sleep Duration", sleepStat.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlueLight))
            .interpolationMethod(.cardinal)
            LineMark(
                x: .value("Weekday", CustomDateFormatter.shared.formatDayMonth(sleepStat.createAt)),
                y: .value("Sleep Duration", sleepStat.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlue))
            .interpolationMethod(.cardinal)
            PointMark(
                x: .value("Weekday", CustomDateFormatter.shared.formatDayMonth(sleepStat.createAt)),
                y: .value("Sleep Duration", sleepStat.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlue))
            .symbolSize(20)
        }.chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 5))
        }
        .onAppear() {
        }
    }
}

extension HomeView: HomeViewProtocol {
    // TODO: implement view output methods
}


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

class HomeView: UIViewController {
    // TODO: Pasos para gestionar los datos de las entradas en la view
    // 6 - Opción de eliminar todas las entradas
    
    @IBOutlet weak var sleepDurationView: UIView!
    @IBOutlet weak var sleepDurationSubview: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sleepStatsDataView: UIView!
    @IBOutlet weak var sleepStatsView: UIView!
    
    @IBOutlet weak var yearSleepDuration: UILabel!
    @IBOutlet weak var yearSleepStats: UILabel!
    
    var viewModel = HomeViewModel()
    
    // MARK: Protocol Properties
    var presenter: HomePresenterProtocol?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpView()
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
        presenter?.didClickEntryAlertView()
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        presenter?.showSettingsView()
    }
    
    @IBAction func lastWeekButtonPressed(_ sender: UIButton) {
//        print("BUTTON LAST: \(viewModel.sleepStats[0].year) - \(viewModel.sleepStats[1].year) - \(viewModel.sleepStats[2].year) - \(viewModel.sleepStats[3].year) - \(viewModel.sleepStats[4].year) - \(viewModel.sleepStats[5].year) - \(viewModel.sleepStats[6].year)")
//        print("BUTTON LAST: \(viewModel.sleepStats[0].weekOfYear) - \(viewModel.sleepStats[1].weekOfYear) - \(viewModel.sleepStats[2].weekOfYear) - \(viewModel.sleepStats[3].weekOfYear) - \(viewModel.sleepStats[4].weekOfYear) - \(viewModel.sleepStats[5].weekOfYear) - \(viewModel.sleepStats[6].weekOfYear)")
        
        presenter?.didClickLastWeek(weekOfYear: viewModel.sleepStats[0].weekOfYear, year: viewModel.sleepStats[0].year)
        print(viewModel.sleepStats[0].date)
        print(viewModel.sleepStats[0].dateString)
        print(viewModel.sleepStats[0].weekOfYear)
    }
    
    @IBAction func nextWeekButtonPressed(_ sender: UIButton) {
        presenter?.didClickNextWeek(weekOfYear: viewModel.sleepStats[0].weekOfYear, year: viewModel.sleepStats[0].year)
    }
}

extension HomeView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sleepStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleepStatsCell") as! HomeViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.setup(timeOfSleep: viewModel.sleepStats[indexPath.row].timeOfSleep ,
                   wakeupTIme: viewModel.sleepStats[indexPath.row].wakeUpTime ,
                   sleepDuration: viewModel.sleepStats[indexPath.row].sleepDuration,
                   weekday: viewModel.sleepStats[indexPath.row].dateString )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7
    }
}

extension HomeView: HomeViewProtocol {
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showSleepStats(_ sleepStats: [SleepStat]) {
        viewModel.sleepStats = sleepStats
        yearSleepStats.text = sleepStats[0].year
        yearSleepDuration.text = sleepStats[0].year
        
        print("BUTTON LAST: \(viewModel.sleepStats[0].date) - \(viewModel.sleepStats[1].date) - \(viewModel.sleepStats[2].date) - \(viewModel.sleepStats[3].date) - \(viewModel.sleepStats[4].date) - \(viewModel.sleepStats[5].date) - \(viewModel.sleepStats[6].date)")
        print("BUTTON LAST: \(viewModel.sleepStats[0].dateString) - \(viewModel.sleepStats[1].dateString) - \(viewModel.sleepStats[2].dateString) - \(viewModel.sleepStats[3].dateString) - \(viewModel.sleepStats[4].dateString) - \(viewModel.sleepStats[5].dateString) - \(viewModel.sleepStats[6].dateString)")
         
    }
    
    func showResetEntryData(_ sleepTime: Date, _ wakeUpTime: Date, _ sleepDuration: String) {}
    func showDurationFromEntryChanges(_ sleepDuration: String) {}
}

// MARK: setup view
extension HomeView {
    private func setUpView() {
        view.backgroundColor = .customLight
        
        // Sleep Stats table configuration
        sleepStatsView.layer.cornerRadius = 15
        sleepStatsView.layer.shadowColor = UIColor.black.cgColor
        sleepStatsView.layer.shadowOpacity = 0.8
        sleepStatsView.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        sleepStatsDataView.backgroundColor = .customBlueLight
        sleepStatsDataView.layer.cornerRadius = 10
        
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.isScrollEnabled = false
        tableView.delegate = self
        
        sleepDurationView.layer.cornerRadius = 15
        sleepDurationView.layer.shadowColor = UIColor.black.cgColor
        sleepDurationView.layer.shadowOpacity = 0.8
        sleepDurationView.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        // Sleep duration graph view configuration
        let controller = UIHostingController(rootView: HomeSleepStatChart(viewModel: self.viewModel))
        guard let sleepDurationGraphView = controller.view else {
            print("Graph view not found")
            return
        }
        
        sleepDurationView.addSubview(sleepDurationGraphView)
        
        // Add constraints
        sleepDurationGraphView.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sleepDurationView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 20)
        let trailingConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sleepDurationView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -20)
        let topConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sleepDurationView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 50)
        let bottomConstraint = NSLayoutConstraint(item: sleepDurationGraphView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sleepDurationView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -20)

        sleepDurationView.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        
        tableView.dataSource = self
    }
}


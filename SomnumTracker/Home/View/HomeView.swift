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
    // 1 - almacenar en array de tipo SleepStat interno
    // 2 - Al arrancar, saber qué semana es la actual
    // 3 - leer del almacenamiento interno el array entero y coger todos los datos (si hay)
    // pertenecientes a esa semana
    // 4 - Los días de esa semana que no tengan datos se mostrarán con este símbolo: "-"
    // 5 - Si añadimos una entrada ya existente, se sobreescribirá
    // 6 - Opción de eliminar todas las entradas
    
    
    @IBOutlet weak var sleepDurationView: UIView!
    @IBOutlet weak var sleepDurationSubview: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sleepStatsDataView: UIView!
    @IBOutlet weak var sleepEntryButton: UIButton!
    @IBOutlet weak var sleepStatsView: UIView!
    
    var viewModel = HomeViewModel()
    
    // MARK: Protocol Properties
    var presenter: HomePresenterProtocol?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        presenter?.viewDidLoad()
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
        presenter?.didClickEntryAlertView()
    }
}

extension HomeView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //viewModel.sleepStats.count
        return 31
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleepStatsCell") as! HomeViewCell
        cell.backgroundColor = UIColor.clear
        
//        cell.setup(timeOfSleep: viewModel.sleepStats[indexPath.row].timeOfSleep ?? "",
//                   wakeupTIme: viewModel.sleepStats[indexPath.row].wakeUpTime ?? "",
//                   sleepDuration: viewModel.sleepStats[indexPath.row].sleepDuration,
//                   weekday: viewModel.sleepStats[indexPath.row].dateString ?? "")
        //TEST LIMITS
        cell.setup(timeOfSleep: "10:58",
                   wakeupTIme: "21:30",
                   sleepDuration: 10,
                   weekday: "31/12")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 31
    }
}

extension HomeView: HomeViewProtocol {
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showSleepStats(_ sleepStats: [SleepData]) {
        viewModel.sleepStats = sleepStats
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
        sleepEntryButton.tintColor = .customBlue
        
        sleepEntryButton.titleLabel?.isHidden = true
        
        // Sleep duration graph view configuration
        let controller = UIHostingController(rootView: HomeSleepStatChart(viewModel: self.viewModel))
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
        
        tableView.dataSource = self
    }
}


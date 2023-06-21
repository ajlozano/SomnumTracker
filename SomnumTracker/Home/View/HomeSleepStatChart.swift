//
//  HomeSleepStatChart.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 5/5/23.
//

import Foundation
import SwiftUI
import Charts

struct HomeSleepStatChart: View {
    // MARK: - Properties
    @ObservedObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - SwiftUI Chart view
    var body: some View {
        Chart(viewModel.sleepStats) { sleepStat in
            AreaMark(
                x: .value("Weekday", sleepStat.dateString),
                y: .value("Sleep Duration", sleepStat.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlueLessAlpha))
            .interpolationMethod(.cardinal(tension: 0.4))
            LineMark(
                x: .value("Weekday", sleepStat.dateString),
                y: .value("Sleep Duration", sleepStat.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlue))
            .interpolationMethod(.cardinal(tension: 0.4))
            PointMark(
                x: .value("Weekday", sleepStat.dateString),
                y: .value("Sleep Duration", sleepStat.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlue))
            .symbolSize(20)
        }.chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 5))
        }
    }
}


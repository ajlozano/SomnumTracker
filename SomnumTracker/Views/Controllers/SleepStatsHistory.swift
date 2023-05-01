//
//  SleepStatsHistory.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 26/4/23.
//

import SwiftUI
import Charts
import Foundation

struct SleepStatsHistory: View {
    private let homeViewModel = HomeViewModel()
    
    var body: some View {
        // TODO: Fix use of homeViewModel.list as MVVM
        Chart(homeViewModel.list) { sleepStatModel in
            AreaMark(
                x: .value("Weekday", CustomDateFormatter.shared.format(sleepStatModel.createAt)),
                y: .value("Sleep Duration", sleepStatModel.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlueLight))
            .interpolationMethod(.cardinal)
            LineMark(
                x: .value("Weekday", CustomDateFormatter.shared.format(sleepStatModel.createAt)),
                y: .value("Sleep Duration", sleepStatModel.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlue))
            .interpolationMethod(.cardinal)
            PointMark(
                x: .value("Weekday", CustomDateFormatter.shared.format(sleepStatModel.createAt)),
                y: .value("Sleep Duration", sleepStatModel.sleepDuration)
            )
            .foregroundStyle(Color(UIColor.customBlue))
            .symbolSize(20)
        }.chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 5))
        }
    }
}


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
    @StateObject var homeViewModel = HomeViewModel()
    @State var sleepStats = [SleepStats]()
 
    var body: some View {
        // TODO: Fix use of homeViewModel.list as MVVM
        Chart(homeViewModel.sleepStats) { sleepStat in
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


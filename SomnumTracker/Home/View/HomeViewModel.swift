//
//  HomeViewModel.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 27/4/23.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    // MARK: - Properties
    @Published var sleepStats = [SleepStat]()
}

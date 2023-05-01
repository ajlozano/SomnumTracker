//
//  dateFormatter.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 1/5/23.
//

import Foundation

struct CustomDateFormatter {
    static var shared = CustomDateFormatter()
    
    mutating func format(_ date: Date) -> String {
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.day, .month], from: date)
        guard let day = dateComponents.day, let month = dateComponents.month else {
            return "-"
        }
        return "\(day)/\(month)"
    }
}

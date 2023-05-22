//
//  dateFormatter.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 1/5/23.
//

import Foundation

struct CustomDateFormatter {
    static var shared = CustomDateFormatter()
    
    static var dateFormat: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }()
    
    static var timeFormat: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
    
    mutating func formatDayMonth(_ date: Date) -> String {
//        var cal = Calendar(identifier: .gregorian)
//        cal.locale = NSLocale.current
//        cal.firstWeekday = 2
        print(date)
        let dateComponents = Calendar.current.dateComponents([.day, .month], from: date)

        guard let day = dateComponents.day, let month = dateComponents.month else {
            return "-"
        }
        let dayString = String(format: "%02d", day)
        let monthString = String(format: "%02d", month)
        
        print(day)
        
        return dayString + "/" + monthString
    }
    
    mutating func formatYear(_ date: Date) -> String {
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.year], from: date)
        guard let year = dateComponents.year else {
            return "-"
        }
        
        let yearString = String(format: "%04d", year)
        
        return yearString
    }
    
    mutating func formatHourMinute(_ date: Date) -> String {
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.hour, .minute], from: date)
        guard let hour = dateComponents.hour, let minute = dateComponents.minute else {
            return "-"
        }
        let hourString = String(format: "%02d", hour)
        let minuteString = String(format: "%02d", minute)
        
        
        return hourString + ":" + minuteString
    }
}

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}

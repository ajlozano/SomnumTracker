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
    
    mutating func formatDayMonth(_ day: Int, _ month: Int) -> String {
        let dayString = String(format: "%02d", day)
        let monthString = String(format: "%02d", month)
        
        return dayString + "/" + monthString
    }
    
    mutating func formatHourMinute(_ hour: Int, _ minute: Int) -> String {
        let hourString = String(format: "%02d", hour)
        let minuteString = String(format: "%02d", minute)
        
        return hourString + ":" + minuteString
    }
    
    func getCalendar() -> Calendar {
        var calendar = Calendar.current
        //calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.firstWeekday = 2   // Weekday -> Monday
        return calendar
    }
}

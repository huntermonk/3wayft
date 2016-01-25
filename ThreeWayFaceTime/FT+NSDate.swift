//
//  FT+NSDate.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/25/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation

extension NSDate {
    
    func returnString() -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        
        if NSCalendar.currentCalendar().isDateInToday(self) == true {
            return formatter.stringFromDate(self)
        }
        
        if NSCalendar.currentCalendar().isDateInYesterday(self) == true {
            return "Yesterday"
        }
        
        if occuredInPastWeek() == true {
            let components = NSCalendar.currentCalendar().components([NSCalendarUnit.Weekday], fromDate: self)
            return weekdayName(components.weekday)
        }
        
        return formatter.stringFromDate(self)
        
    }
    
    // TODO: - This doesn't actually work correctly because it's based on seconds and not days.
    private func occuredInPastWeek() -> Bool {
        
        if self.timeIntervalSinceNow < 604800 {
            return true
        }
        
        return false
        
    }
    
    // TODO: - How can I make this argument NSCalendarUnit.Weekday?
    private func weekdayName(day:Int) -> String {
    
        switch day {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    
    }
    
}
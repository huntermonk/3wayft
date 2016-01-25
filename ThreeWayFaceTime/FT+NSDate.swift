//
//  FT+NSDate.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/25/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation

extension NSDate {
    
    func returnTimeSince() -> String {
        
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
        
        //let components = NSCalendar.currentCalendar().components([NSCalendarUnit.], fromDate: <#T##NSDate#>)
        
        if elapsedTime / 3600 > 24 {
            
            if Int(elapsedTime/86400) == 1 {
                returnString = "Yesterday"
            } else {
                returnString = "\(Int(elapsedTime/86400)) Days ago"
            }
            
        } else if elapsedTime / 3600 < 24 && elapsedTime / 60 >= 60 {
            
            if Int(elapsedTime/3600) == 1 {
                returnString = "An hour ago"
            } else {
                returnString = "\(Int(elapsedTime/3600)) Hours ago"
            }
            
        } else {
            
            if Int(elapsedTime/60) == 0 || Int(elapsedTime/60) == 1 {
                returnString = "Just Now"
            } else {
                returnString = "\(Int(elapsedTime/60)) Minutes ago"
            }
            
        }
        return returnString
        
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
    
/*
    -(BOOL) dayOccuredDuringLast7Days
    {
    
    NSDate *now = [NSDate date];  // now
    NSDate *today;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit // beginning of this day
    startDate:&today // save it here
    interval:NULL
    forDate:now];
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.day = -7;      // lets go 7 days back from today
    NSDate * oneWeekBefore = [[NSCalendar currentCalendar] dateByAddingComponents:comp
    toDate:today
    options:0];
    
    
    if ([self compare: oneWeekBefore] == NSOrderedDescending) {
    
    if ( [self compare:today] == NSOrderedAscending ) { // or now?
    return YES;
    }
    }
    return NO;
    }*/
    
}
//
//
//  DateFormatters.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 28/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

class DateFormatters {
    static var db_versionDateFormat = "yyyyMMddHHmm"
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = db_versionDateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
}

extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self)
    }
    
    func toDbVersionDateformatString() -> String {
        return DateFormatters.dateFormatter.string(from: self)
    }

    static var localeDate: Date {
        let localeDateString = Date().convertToString(Format: "yyyy-MM-dd HH:mm:ss", local: true)
        let localeDate = localeDateString?.convertToDate("yyyy-MM-dd HH:mm:ss", utc: true)
        
        return localeDate ?? Date()
    }
    
    func convertToString(Format format:String, local:Bool) -> String! {
        var dateString : String!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if !local {
            let zone = NSTimeZone(name: "UTC")! as TimeZone
            dateFormatter.timeZone = zone
        }
        
        dateString = dateFormatter.string(from: self)
        
        return dateString
    }
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date, isNotification: Bool? = false) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))m"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
       // if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
       // if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return (isNotification ?? false) ? "now" : "Just Now!"
    }
}

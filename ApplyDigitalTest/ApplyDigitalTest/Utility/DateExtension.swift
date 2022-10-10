//
//  DateExtension.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 10/10/22.
//

import Foundation

extension Date {
//    /// Returns the amount of years from another date
//    func years(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
//    }
//    /// Returns the amount of months from another date
//    func months(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
//    }
//    /// Returns the amount of weeks from another date
//    func weeks(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
//    }
//    /// Returns the amount of days from another date
//    func days(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
//    }
//    /// Returns the amount of hours from another date
//    func hours(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
//    }
//    /// Returns the amount of minutes from another date
//    func minutes(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
//    }
//    /// Returns the amount of seconds from another date
//    func seconds(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
//    }
//    /// Returns the a custom time interval description from another date
//    func offsetLong(from date: Date) -> String {
//            if years(from: date) > 0 {
//                return years(from: date) > 1 ? "\(years(from: date)) years ago" : "\(years(from: date)) year ago"
//            }
//            if months(from: date) > 0 {
//                return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago"
//            }
//            if weeks(from: date) > 0 {
//                return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago"
//            }
//            if days(from: date) > 0 {
//                return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago"
//            }
//            if hours(from: date) > 0 {
//                return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago"
//            }
//            if minutes(from: date) > 0 {
//                return minutes(from: date) > 1 ? "\(minutes(from: date)) minutes ago" : "\(minutes(from: date)) minute ago"
//            }
//            if seconds(from: date) > 0 {
//                return seconds(from: date) > 1 ? "\(seconds(from: date)) seconds ago" : "\(seconds(from: date)) second ago"
//            }
//            return ""
//        }
        
    func convert(startDate: String) -> String {
        
        let fixedDate = startDate.replacingOccurrences(of: ".000Z", with: "+000Z")

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssssZ"
        dateFormatter.string(from: date)

        let fmt = ISO8601DateFormatter()

        let date1 = fmt.date(from: fixedDate)!
        let date2 = fmt.date(from: dateFormatter.string(from: date))!

        let diffs = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
        
        let years = diffs.year!
        let months = diffs.month!
        let days = diffs.day!
        let hours = diffs.hour!
        let minutes = diffs.minute!
        let seconds = diffs.second!
        
        var timeAgo = ""
        
        if (seconds > 0){
            if seconds < 2 {
                timeAgo = "1 sec ago"
            }
            else{
                timeAgo = "\(seconds) secs ago"
            }
        }
        
        if (minutes > 0){
            if minutes < 2 {
                timeAgo = "1 min Ago"
            }
            else{
                timeAgo = "\(minutes) mins ago"
            }
        }
        
        if(hours > 0){
            if hours < 2 {
                timeAgo = "1 hour ago"
            }
            else{
                timeAgo = "\(hours) hours ago"
            }
        }
        
        if (days > 0) {
            if days < 2 {
                timeAgo = "1 day ago"
            }
            else{
                timeAgo = "\(days) days ago"
            }
        }
        
        if(months > 0){
            if months < 2 {
                timeAgo = "1 month ago"
            }
            else{
                timeAgo = "\(months) months ago"
            }
        }
        
        if(years > 0){
            if years < 2 {
                timeAgo = "1 year ago"
            }
            else{
                timeAgo = "\(years) years ago"
            }
        }
        
        print("timeAgo is ===> \(timeAgo)")
        return timeAgo
        
    }
}

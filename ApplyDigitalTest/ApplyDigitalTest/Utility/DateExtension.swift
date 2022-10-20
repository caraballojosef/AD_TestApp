//
//  DateExtension.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 10/10/22.
//

import Foundation

extension Date {
        
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

//
//  DateUtility.swift
//  CalenderApp
//
//  Created by Ankit Garg on 08/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    
    var dateIneeemonInLocal: String {
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.timeZone = TimeZone.ReferenceType.local
        monthYearFormatter.dateFormat = "eee, dd MMM yyyy"
        return monthYearFormatter.string(from: self)
    }
    
    var dateIneeemon: String {
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.dateFormat = "eee, dd MMM"
        return monthYearFormatter.string(from: self)
    }
    
    var dateInDDMMMInLocal: String {
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.timeZone = TimeZone.ReferenceType.local
        monthYearFormatter.dateFormat = "dd MMM"
        return monthYearFormatter.string(from: self)
    }
    
    var dateInDDMMM: String {
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.dateFormat = "dd MMM"
        return monthYearFormatter.string(from: self)
    }
    var monthStr : String{
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.timeZone = TimeZone.ReferenceType.local
        
        monthYearFormatter.dateFormat = "MMM"
        
        return monthYearFormatter.string(from: self)
    }
    
    var day : String{
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.timeZone = TimeZone.ReferenceType.local
        
        monthYearFormatter.dateFormat = "eee"
        
        return monthYearFormatter.string(from: self)
    }
    
    var dateStr : String{
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.timeZone = TimeZone.ReferenceType.local
        
        monthYearFormatter.dateFormat = "dd"
        
        return monthYearFormatter.string(from: self)
    }
    var year : String{
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.timeZone = TimeZone.ReferenceType.local
        
        monthYearFormatter.dateFormat = "yyyy"
        
        return monthYearFormatter.string(from: self)
    }
    
    var time : String{
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.timeZone = TimeZone.ReferenceType.local
        
        monthYearFormatter.dateFormat = "hh:mm a"
        
        return monthYearFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}


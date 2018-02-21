//
//  DateUtility.swift
//  CalenderApp
//
//  Created by Ankit Garg on 08/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import Foundation

extension Date {
    
    var dateIneeemonInLocal: String {
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.timeZone = TimeZone.ReferenceType.local
        monthYearFormatter.dateFormat = "eee, dd MMM yyyy"
        return monthYearFormatter.string(from: self)
    }
    
    var dateInDDMMMInLocal: String {
        let monthYearFormatter =  DateFormatter()
        monthYearFormatter.timeZone = TimeZone.ReferenceType.local
        monthYearFormatter.dateFormat = "dd MMM"
        return monthYearFormatter.string(from: self)
    }
    
}


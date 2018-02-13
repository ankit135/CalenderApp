//
//  WeatherData.swift
//  CalenderApp
//
//  Created by Ankit Garg on 12/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit

class WeatherData: NSObject {

    var date : Date?
    var summary : String?
    var icon : String?
    
    init(dict : [String:AnyObject]) {
        if let dateNS = dict["time"] as? NSNumber{
            self.date = Date(timeIntervalSince1970: TimeInterval(truncating: dateNS))
            
        }
        self.summary = dict["summary"] as? String
        self.icon = dict["icon"] as? String
    }
}

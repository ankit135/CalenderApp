//
//  EventData.swift
//  CalenderApp
//
//  Created by Ankit Garg on 08/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit

class EventData: NSObject {
    
    var eventName : String?
    var eventDate : Date?
    var icon : String?
    var type : Int16?
    
    init(eventName : String?, eventDate : Date?, icon : String?, type : Int16?) {
        self.eventDate = eventDate
        self.eventName = eventName
        self.icon = icon
        self.type = type
    }
    

}

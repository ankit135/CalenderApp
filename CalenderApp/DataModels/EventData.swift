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
    
    init(eventName : String?, eventDate : Date?) {
        self.eventDate = eventDate
        self.eventName = eventName
    }
    

}

//
//  EventSectionsData.swift
//  CalenderApp
//
//  Created by Ankit Garg on 09/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit

class EventSectionsData: NSObject {

    var date : Date?
    var eventData : [EventData] = []
    
    init(date : Date, eventData : [EventData]) {
        self.date  = date
        self.eventData = eventData
    }
    
}

//
//  CalenderDataVader.swift
//  CalenderApp
//
//  Created by Ankit Garg on 08/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit
import CoreData

public let startDate = Date()
public let endDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30 * 12 * 0.5)

class CalenderDataVader: NSObject {
    
    static let sharedInstance = CalenderDataVader()
    
    func getTotalEventsData() -> [EventSectionsData]{
        var daysInaYear : [Date] = []
        var eventsSections : [EventSectionsData] = []
        daysInaYear.append(Date())
        let calendar = NSCalendar.current
        
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        if let components = calendar.dateComponents([.day], from: date1, to: date2).day{
            for i in 1...components{
                var dateComponents = DateComponents()
                dateComponents.day = 1
                if let futureDate = calendar.date(byAdding: dateComponents, to: daysInaYear[i-1]){
                     daysInaYear.append(futureDate)
                }
            }
        }
        
        if let totalEvents = fetchEvents(){
            for day in daysInaYear{
                var eventData : [EventData] = []
                for event in totalEvents{
                    if let date = event.date{
                        let eventDate = date as Date
                        if eventDate.dateIneeemonInLocal == day.dateIneeemonInLocal{
                            
                            let data = EventData(eventName: event.name, eventDate: event.date! as Date)
                            eventData.append(data)
                        }
                    }
                    
                }
                eventsSections.append(EventSectionsData(date: day, eventData: eventData))
            }
        }
        
        return eventsSections
        
    }
    
    func saveEvent(eventTitle : String, date : Date){
        let entity =
            NSEntityDescription.entity(forEntityName: "Events",
                                       in: managedObjectContext)!
        
        let record : Events = NSManagedObject(entity: entity,
                                                         insertInto: managedObjectContext) as! Events
        
        record.name = eventTitle
        record.date = date as NSDate
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save Event. \(error), \(error.userInfo)")
        }
    }
    
    func fetchEvents() -> [Events]?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
        
        var results : [Events]?
        do{
            results = try managedObjectContext.fetch(request) as? [Events]
        }
        catch let error as NSError {
            print("Events Fetch failed: \(error.localizedDescription)")
        }
        
        return results
    }
    
    
    
    // MARK:- CoreData Methods
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "CalenderApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        var db = "CalenderData_v1.sqlite"
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent(db)
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

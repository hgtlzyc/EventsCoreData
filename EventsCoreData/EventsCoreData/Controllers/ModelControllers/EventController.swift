//
//  EventController.swift
//  EventsCoreData
//
//  Created by lijia xu on 7/30/21.
//

import CoreData

/// Conforms to EventScheduler which has default implemenation for schedule notifications
class EventController: EventScheduler {
    
    static let shared = EventController()
    
    
    // MARK: - Fetch Related
    func getEvents() -> [Event] {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        do {
            return try CoreDataStack.context.fetch(fetchRequest)
        } catch {
            print("Error get Events \(error)")
            return []
        }
    }
    
    // MARK: - CRUD Functions
    
    func createNewEvent(name: String, eventDate: Date, willAttend: Bool) {
        let newEvent = Event(name: name, eventDate: eventDate, willAttend: willAttend)
       
        saveContextAndChangeNotification(for: newEvent, shouldOn: newEvent.willAttend)
        
    }
    
    func updateEvent(_ event: Event, name: String, eventDate: Date) {
        event.eventName = name
        event.eventDate = eventDate
       
        saveContextAndChangeNotification(for: event, shouldOn: event.willAttend)
        
    }
    
    func toggleEventWillAttendStatus(_ event: Event) {
        event.willAttend.toggle()
        
        saveContextAndChangeNotification(for: event, shouldOn: event.willAttend)
        
    }
    
    func deleteEvent(_ event: Event) {
        CoreDataStack.context.delete(event)
        
        saveContextAndChangeNotification(for: event, shouldOn: false)
        
    }
    
    // MARK: - Save Context and Notification Helper
    
    func saveContextAndChangeNotification(for event: Event, shouldOn: Bool) {
        CoreDataStack.saveContext()
        
        changeNotification(for: event, shouldOn: shouldOn)
        
    }
    
    
    // MARK: - Change Notification Helper
    func changeNotification(for event: Event, shouldOn: Bool) {
        cancelEventNotification(for: event)
        
        if shouldOn {
            scheduleEventNotification(for: event)
        }
    }
    
    // MARK: - Private Init
    private init(){}
}

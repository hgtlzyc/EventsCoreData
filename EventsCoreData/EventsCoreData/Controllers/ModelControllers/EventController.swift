//
//  EventController.swift
//  EventsCoreData
//
//  Created by lijia xu on 7/30/21.
//

import CoreData

class EventController {
    
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
        Event(name: name, eventDate: eventDate, willAttend: willAttend)
        
        CoreDataStack.saveContext()
    }
    
    func updateEvent(_ event: Event, name: String, eventDate: Date) {
        event.eventName = name
        event.eventDate = eventDate
        
        CoreDataStack.saveContext()
        
    }
    
    func toggleEventWillAttendStatus(_ event: Event) {
        event.willAttend.toggle()
        
        CoreDataStack.saveContext()
    }
    
    func deleteEvent(_ event: Event) {
        CoreDataStack.context.delete(event)
        
        CoreDataStack.saveContext()
    }
    
    
    // MARK: - Private Init
    private init(){}
}

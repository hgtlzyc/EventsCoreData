//
//  EventController.swift
//  EventsCoreData
//
//  Created by lijia xu on 7/30/21.
//

import CoreData

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
       
        CoreDataStack.saveContext()
        
        changeNotification(for: newEvent, shouldOn: newEvent.willAttend)
        
    }
    
    func updateEvent(_ event: Event, name: String, eventDate: Date) {
        event.eventName = name
        event.eventDate = eventDate
       
        CoreDataStack.saveContext()
        
        changeNotification(for: event, shouldOn: event.willAttend)
        
    }
    
    func toggleEventWillAttendStatus(_ event: Event) {
        event.willAttend.toggle()
        
        CoreDataStack.saveContext()
        
        changeNotification(for: event, shouldOn: event.willAttend)
        
    }
    
    func deleteEvent(_ event: Event) {
        CoreDataStack.context.delete(event)
        
        CoreDataStack.saveContext()
        
        changeNotification(for: event, shouldOn: false)
        
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

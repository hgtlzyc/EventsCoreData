# EventsCoreData Friday Solo Project

<br />

code snippets

```swift
//MARK: - Raw Data sorting related
extension EventListTableViewController {
    
    enum EventsSortingProperty{
        case date
    }
    
    ///Changing the Value of events: [Event]!, does NOT check tableView.hasUncommittedUpdates
    func loadEvents(reloadTable: Bool, sortBy: EventsSortingProperty = .date, isAssending: Bool = false) {
        let eventsRaw = EventController.shared.getEvents()
        
        var sortedEvents: [Event]?
        
        switch sortBy {
        case .date:
            sortedEvents = sortedEventsByDate(from: eventsRaw, isAssending: isAssending)
            
        }//
        
        switch sortedEvents {
        case let sortedEvents?:
            self.events = sortedEvents
            
        case nil:
            self.events = []
            
        }//
        
        if reloadTable { tableView.reloadData() }
    }
    
    func sortedEventsByDate(from eventsRaw: [Event], isAssending: Bool) -> [Event]? {
        let validDatesCount = eventsRaw.compactMap{$0.eventDate}.count
        
        guard eventsRaw.count == validDatesCount else {
            print("\(eventsRaw.count - validDatesCount) nil event date")
            return nil
        }
        
        //If Date same will be sort by name
        func isEventAssendingDate(_ lh: Event, _ rh: Event) -> Bool {
            guard lh.eventDate! != rh.eventDate! else {
                return (lh.eventName?.first ?? "a" ) < ( rh.eventName?.first ?? "a" )
            }
            
            return lh.eventDate! > rh.eventDate!
        }
        
        switch isAssending {
        case true: return eventsRaw.sorted(by: isEventAssendingDate)
        case false: return eventsRaw.sorted(by: isEventAssendingDate)
        }
        
    }//End Of sortedEventsByDate
    
    
}//End Of Extension


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

```
 

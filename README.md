# EventsCoreData Friday Solo Project
[Go To My Resume](https://github.com/hgtlzyc/Resume#events-reminder-github-repo)
<br />

code snippet

```swift
//MARK: - Raw Data sorting related
extension EventListTableViewController {
    
    enum EventsSortingProperty{
        case date
    }
    
    enum SortingError: Error {
        case nilDateInArray(message: String,eventSet: Set<Event>)
    }
    
    ///Changing the Value of events: [Event]!, does NOT check tableView.hasUncommittedUpdates
    func loadEvents(reloadTable: Bool, sortBy: EventsSortingProperty = .date, isAssending: Bool = false) {
        let eventsRaw = EventController.shared.getEvents()
        
        var sortedEvents: [Event]?
        
        switch sortBy {
        case .date:
            sortedEventsByDate(from: eventsRaw, isAssending: isAssending){ result in
                switch result {
                case let .success(events):
                    sortedEvents = events
                case let .failure( .nilDateInArray(message,eventSet) ):
                    //TODO change to user alerts
                    print(message)
                    print(eventSet)
                }
            }//end of .date
            
        }//end or switch
        
        switch sortedEvents {
        case let sortedEvents?:
            self.events = sortedEvents
            
        case nil:
            self.events = []
            
        }//end of switch
        
        if reloadTable { tableView.reloadData() }
    }
    
    func sortedEventsByDate(from eventsRaw: [Event], isAssending: Bool, completion: (_ result:  Result<[Event], SortingError>) -> Void) {
        let validDatesCount = eventsRaw.compactMap{$0.eventDate}.count
        
        if eventsRaw.count != validDatesCount {
            let eventsWithNilDates = findEventsWithNilDate(eventsRaw)
            
            completion(
                .failure(
                    .nilDateInArray(
                        message: "\(eventsRaw.count - validDatesCount) nil event date",
                        eventSet: eventsWithNilDates
                    )
                )
            )//end of completion
        }//
        
        /// Date will be sorted by assending or desending,
        /// If date the same will be sorted by name
        func eventDisplayOrder(_ lh: Event, _ rh: Event, basedOn shouldAssending: Bool) -> Bool {
            guard lh.eventDate! != rh.eventDate! else {
                return (lh.eventName?.first ?? "a" ) < ( rh.eventName?.first ?? "a" )
            }
            
            let isDateAssending = lh.eventDate! < rh.eventDate!
            return shouldAssending ? isDateAssending : !isDateAssending
        }
        
        func topToBottomDisplayPredicate(_ lh: Event, _ rh: Event) -> Bool {
            return eventDisplayOrder(lh, rh, basedOn: isAssending)
        }
        
        completion(
            .success(
                eventsRaw.sorted(by: topToBottomDisplayPredicate)
            )
        )
        
    }//End Of sortedEventsByDate
    
    // MARK: - bug info helper
    func findEventsWithNilDate(_ rawEvents: [Event]) -> Set<Event>{
        let validEvents = Set( rawEvents.filter{$0.eventDate != nil} )
        let rawEvents = Set( rawEvents )
        
        return rawEvents.subtracting(validEvents)
    }
    
}//End Of Extension
 

//
//  EventListTableViewController.swift
//  EventsCoreData
//
//  Created by lijia xu on 7/30/21.
//

import UIKit

class EventListTableViewController: UITableViewController {
    
    // MARK: - String Constants
    let eventCellID = kStringConstants.StoryBoardIDs.eventVCCellID
    let toDetailVCSegueID = kStringConstants.StoryBoardIDs.toDetailVCSegue
    
    // MARK: - Vars
    var events: [Event]!
    
    //Search Bar
    let searchController : UISearchController = {
        let controller = UISearchController()
        controller.hidesNavigationBarDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = false
        
        return controller
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEvents(reloadTable: false)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadEvents(reloadTable: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: eventCellID, for: indexPath) as? EventTableViewCell else { return UITableViewCell() }
        
        let eventSelected = events[indexPath.row]
        
        cell.updateViews(event: eventSelected)
        cell.delegate = self

        return cell
    }
    
    // MARK: - Delete Related
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedEvent = events[indexPath.row]
            EventController.shared.deleteEvent(selectedEvent)
            loadEvents(reloadTable: false)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toDetailVCSegueID {
            guard let targetVC = segue.destination as? EventDetailViewController,
                  let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            
            let selectedEvent = events[selectedIndexPath.row]
            targetVC.event = selectedEvent
            
        }
    }

} //End Of VC


// MARK: - Event Cell Delegate
extension EventListTableViewController: EventCellDelegate {
    func willAttendStatusButtonTapped(in cell: EventTableViewCell) {
        guard let selectedIndexPath = tableView.indexPath(for: cell) else { return }
        let selectedEvent = events[selectedIndexPath.row]
        EventController.shared.toggleEventWillAttendStatus(selectedEvent)
        loadEvents(reloadTable: true)
    }
    
}

//MARK: - Data Search Related
extension EventListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchKey = searchController.searchBar.text else { return }
       
        
        
    }
}

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


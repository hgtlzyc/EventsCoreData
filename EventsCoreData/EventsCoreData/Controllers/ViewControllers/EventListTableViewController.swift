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
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEvents(reloadTable: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadEvents(reloadTable: true)
    }
    
    
    // MARK: - Reduce the calls to CoreData
    func loadEvents(reloadTable: Bool) {
        events = EventController.shared.getEvents()
        
        if reloadTable {
            tableView.reloadData()
        }
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

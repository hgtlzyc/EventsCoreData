//
//  EventDetailViewController.swift
//  EventsCoreData
//
//  Created by lijia xu on 7/30/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var eventStatusLabel: UILabel!
    
    @IBOutlet weak var eventTitleTF: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var event: Event?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let event = event else {
            eventStatusLabel.text = "Create New Event"
            datePicker.date = Date()
            return
        }
        eventStatusLabel.text = "Update Event"
        eventTitleTF.text = event.eventName
        datePicker.date = event.eventDate ?? Date()
    }

    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let nameText = eventTitleTF.text, !nameText.isEmpty else { return }
        let date = datePicker.date
        createOrUpdateEvent(name: nameText, date: date)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        guard let event = event, let name = event.eventName else { return }
        EventController.shared.updateEvent(event, name: name, eventDate: sender.date)
    }
    
    func createOrUpdateEvent(name: String, date: Date) {
        switch event {
        case let event?:
            EventController.shared.updateEvent(event, name: name, eventDate: date)
        case nil:
            EventController.shared.createNewEvent(name: name, eventDate: date, willAttend: true)
        }
    }
    
    

}//End Of VC

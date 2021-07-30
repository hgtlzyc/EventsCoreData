//
//  EventTableViewCell.swift
//  EventsCoreData
//
//  Created by lijia xu on 7/30/21.
//

import UIKit

protocol EventCellDelegate: AnyObject {
    func willAttendStatusButtonTapped(in cell: EventTableViewCell)
}

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var willAttendStatusButton: UIButton!
    
    weak var delegate: EventCellDelegate?
    
    func updateViews(event: Event) {
        self.eventNameLabel.text = event.eventName
        
        let imageForStatusButton = event.willAttend ? UIImage(systemName: "clock.fill") : UIImage(systemName: "clock")
        self.willAttendStatusButton.setImage(imageForStatusButton, for: .normal)
    }
    
    
    @IBAction func willAttendStatusTapped(_ sender: UIButton) {
        delegate?.willAttendStatusButtonTapped(in: self)
    }
    
}

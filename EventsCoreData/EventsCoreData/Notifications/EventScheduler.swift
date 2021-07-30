//
//  EventScheduler.swift
//  EventsCoreData
//
//  Created by lijia xu on 7/30/21.
//

import NotificationCenter

protocol EventScheduler {
    func scheduleEventNotification(for event: Event)
    
    func cancelEventNotification(for event: Event)
    
}

extension EventScheduler {
    
    func scheduleEventNotification(for event: Event) {
        guard let eventUUIDString = event.eventUUID?.uuidString,
              let eventDate = event.eventDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = event.eventName ?? "Event Alert"
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.year, .hour, .minute], from: eventDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: eventUUIDString,
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request) { err in
            if let err = err {
                print("Function: \(#function), line: \(#line)", Date())
                print("\(err)")
            }
        }
        
        
    }
    
    func cancelEventNotification(for event: Event) {
        guard let uuidString = event.eventUUID?.uuidString else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuidString])
    }
}

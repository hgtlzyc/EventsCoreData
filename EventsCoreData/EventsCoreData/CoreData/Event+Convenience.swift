//
//  Event+Convenience.swift
//  EventsCoreData
//
//  Created by lijia xu on 7/30/21.
//

import CoreData

extension Event {
    
    @discardableResult
    convenience init(name: String, eventDate: Date, willAttend: Bool, eventUUID: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.eventName = name
        self.eventDate = eventDate
        self.willAttend = willAttend
        self.eventUUID = eventUUID
    }
    
    
}

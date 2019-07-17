//
//  Entry+Convenience.swift
//  ios-journal
//
//  Created by Dongwoo Pae on 7/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

enum Moods: String {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "😄"
    
    static var allMoods: [Moods] {
        return [.sad, .neutral, .happy]
    }
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = self.title,
            let mood = self.mood,
            let timestamp = self.timestamp else { return nil}
        return EntryRepresentation(title: title, bodyText: bodyText, identifier: identifier?.uuidString ?? "", mood: mood, timestamp: timestamp)
    }
    
    convenience init(title: String, bodyText: String, identifier: UUID = UUID(), timestamp: Date = Date(), mood: Moods = .neutral, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Moods(rawValue: entryRepresentation.mood),
            let identifier = UUID(uuidString: entryRepresentation.identifier) else { return nil}
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText!,
                  identifier: identifier,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood)
    }
    
}

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
    convenience init(title: String, bodyText: String, identifier: String = "", timestamp: Date = Date(), mood: Moods = .neutral, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
}

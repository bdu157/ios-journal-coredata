//
//  Entry+Convenience.swift
//  ios-journal
//
//  Created by Dongwoo Pae on 7/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, identifier: String = "", timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
    }
}

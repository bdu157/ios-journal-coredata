//
//  EntryRepresentation.swift
//  ios-journal
//
//  Created by Dongwoo Pae on 7/16/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    var title: String
    var bodyText: String
    var identifier: String  //string not UUID this time
    var timestamp: Date  //date
    var mood: String  //enum
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return (lhs.title == rhs.title &&
                lhs.bodyText == rhs.bodyText &&
                lhs.mood == rhs.mood &&
                lhs.identifier == rhs.identifier &&
                lhs.timestamp == rhs.timestamp)
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}

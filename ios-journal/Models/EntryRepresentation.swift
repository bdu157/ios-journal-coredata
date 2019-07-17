//
//  EntryRepresentation.swift
//  ios-journal
//
//  Created by Dongwoo Pae on 7/15/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable{
    var title: String
    var bodyText: String?
    var identifier: String
    var mood: String
    var timestamp: Date
}


//
//  EntryController.swift
//  ios-journal
//
//  Created by Dongwoo Pae on 7/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://task-coredata.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    
    //save to the device
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context:\(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
            }
    }
    
    //PUT request
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid.uuidString
            entry.identifier = uuid
            self.saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encdoing entry\(entry): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing task to server:\(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    //DELETE method
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)
            if let error = error {
                NSLog("Error deleting entry: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    
    //CRUD
    
    //Create
    func createEntry(title: String, bodyText: String, mood: Moods) {
        
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        self.put(entry: entry)

        self.saveToPersistentStore()
    }
    
    //Update
    func updateEntry(title: String, bodyText: String, mood: Moods, for entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        
        self.put(entry: entry)
        
        self.saveToPersistentStore()
    }
    
    //Delete
    func deleteEntry(for entry: Entry) {
    
        self.deleteEntryFromServer(entry) { (error) in
            if let error = error {
                NSLog("Error deleting entry from server : \(error)")
                return
            }
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("Error saving managed object context:\(error)")
            }
        }
    }
}

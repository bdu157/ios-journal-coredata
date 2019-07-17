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
    
    
    init() {
        self.fetchEntriesFromServer()
    }
    
    let baseURL = URL(string: "https://task-coredata.firebaseio.com/")!
    
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
    
    //CRUD
    
    //Create
    func createEntry(title: String, bodyText: String, mood: Moods) {
        
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        self.put(entry: entry)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context:\(error)")
        }
    }
    
    //Update
    func updateEntry(title: String, bodyText: String, mood: Moods, for entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        
        self.put(entry: entry)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context:\(error)")
        }
    }
    
    //Delete
    func deleteEntry(for entry: Entry) {
        
        self.deleteTaskFromServer(entry)
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving managed object context:\(error)")
        }
    }
    
    
    //PUT
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in}) {
        let identifier = entry.identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier!).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    //DELETE
    
    func deleteTaskFromServer(_ entry: Entry, completion: @escaping (Error?)->Void = { _ in}) {
        guard let identifier = entry.identifier else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error in deleting entry:\(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    //FetchEntryFromServer (firebase)
    func fetchEntriesFromServer(completion: @escaping (Error?)->Void = { _ in}) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entry : \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error getting data")
                completion(error)
                return
            }
            
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                
                for entryRep in entryRepresentations {
                    let entry = self.fetchSingleEntryFromPersistentStore(forIdentifier: entryRep.identifier) //an Entry from persistentStore that matches entryRep.identifier from decoded data (firebase)
                    if let entry = entry {  //if there is entry that has same identifier as entryRep.identifier
                        if entry != entryRep {  //make sure if there is any difference between entry from persistentstore and firebase
                            self.update(entry: entry, entryRepresentation: entryRep) //update if there is any difference
                        }
                    } else {
                        let _ = Entry(entryRepresentation: entryRep)  //since there is no entry that has identifier that matches entryRep.identifier, create new and save it to 
                    }
                }
                self.saveToPersistentStore()
                completion(nil)
            } catch {
                NSLog("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    
    //UPDATE
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.mood = entryRepresentation.mood
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
    }
    
    //FETCH FROM PersistentStore
    func fetchSingleEntryFromPersistentStore(forIdentifier identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching entry with identifier: \(identifier): \(error)")
            return nil
        }
    }
    
}

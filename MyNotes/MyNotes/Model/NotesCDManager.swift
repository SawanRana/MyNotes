//
//  NotesCDManager.swift
//  MyNotes
//
//  Created by Sawan Rana on 23/06/24.
//

import Foundation
import CoreData

class NotesCDManager {
    static let shared = NotesCDManager(modelName: "MyNotes")
    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: ((Bool)->Void)? = nil ) {
        persistentContainer.loadPersistentStores { desc, error in
            guard error == nil else {
                print("Persistent container fails to load persistent store and error is: \(error!.localizedDescription)")
                completion?(false)
                return
            }
            print("Persistent container load persistent store successfully: \(desc)")
            completion?(true)
        }
    }
    
    public func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error in saving the context: \(error.localizedDescription)")
            }
        }
    }
}

extension NotesCDManager {
    func createNewNote() -> Note {
        let note = Note(context: context)
        note.id = UUID()
        note.lastUpdated = Date()
        note.text = ""
        save()
        return note
    }
    
//    func fetchNotes(filter: String? = nil) -> [Note] {
//        let request: NSFetchRequest<Note> = Note.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
//        request.sortDescriptors = [sortDescriptor]
//        
//        if let filter = filter {
//            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
//            request.predicate = predicate
//        }
//        
//        do {
//            let results = try context.fetch(request)
//            return results
//        } catch {
//            print("Error in fetching the notes: \(error.localizedDescription)")
//        }
//        
//        return []
//    }
    
    func createNoteFetchedResultController(filter: String? = nil) -> NSFetchedResultsController<Note> {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        if let filter = filter {
            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
            request.predicate = predicate
        }
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func deleteNote(_ note: Note) {
        context.delete(note)
        save()
    }
    
    func deleteAll() {
        let fetchRquest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Note")
        let notesBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRquest)
        
        do {
           try context.execute(notesBatchDeleteRequest)
            save()
        } catch {
            print("Unable to remove all notes from storage and error is \(error.localizedDescription)")
        }
    }
}

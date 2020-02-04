//
//  SampleNoteCoreDataHelper.swift
//  SampleNoteApp
//
//  Created by Besta, Balaji (623-Extern) on 04/02/20.
//  Copyright © 2020 Balaji Besta. All rights reserved.
//

import Foundation

import CoreData

class SampleNoteCoreDataHelper {
    
    private(set) static var count: Int = 0
    
    static func createNoteInCoreData(
        noteToBeCreated:          SampleNote,
        intoManagedObjectContext: NSManagedObjectContext) {
        
        // Let’s create an entity and new note record
        let noteEntity = NSEntityDescription.entity(
            forEntityName: "Note",
            in:            intoManagedObjectContext)!
        
        let newNoteToBeCreated = NSManagedObject(
            entity:     noteEntity,
            insertInto: intoManagedObjectContext)

        newNoteToBeCreated.setValue(
            noteToBeCreated.noteId,
            forKey: "noteId")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteTitle,
            forKey: "noteTitle")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteText,
            forKey: "noteText")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteTimeStamp,
            forKey: "noteTimeStamp")
        
        do {
            try intoManagedObjectContext.save()
            count += 1
        } catch let error as NSError {
            // TODO error handling
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //Edited Note
    
    static func changeNoteInCoreData(
        noteToBeChanged:        SampleNote,
        inManagedObjectContext: NSManagedObjectContext) {
        
        // read managed object
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let noteIdPredicate = NSPredicate(format: "noteId = %@", noteToBeChanged.noteId as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try inManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeChanged = fetchedNotesFromCoreData[0] as! NSManagedObject
            
            // make the changes
            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteTitle,
                forKey: "noteTitle")

            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteText,
                forKey: "noteText")

            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteTimeStamp,
                forKey: "noteTimeStamp")

            // save
            try inManagedObjectContext.save()

        } catch let error as NSError {
            // TODO error handling
            print("Could not change. \(error), \(error.userInfo)")
        }
    }
    //Read list from Data
    static func readNotesFromCoreData(fromManagedObjectContext: NSManagedObjectContext) -> [SampleNote] {

        var returnedNotes = [SampleNote]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let sortDescriptor1 = NSSortDescriptor(key: Sort.Date.rawValue, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        fetchRequest.predicate = nil
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                let noteManagedObjectRead = fetchRequestResult as! NSManagedObject
                returnedNotes.append(SampleNote.init(
                    noteId:        noteManagedObjectRead.value(forKey: "noteId")        as! UUID,
                    noteTitle:     noteManagedObjectRead.value(forKey: "noteTitle")     as! String,
                    noteText:      noteManagedObjectRead.value(forKey: "noteText")      as! String,
                    noteTimeStamp: noteManagedObjectRead.value(forKey: "noteTimeStamp") as! Int64))
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
        }
        
        // set note count
        self.count = returnedNotes.count
        
        return returnedNotes
    }
    //Read  search list form Data
    static func readNotesFromCoreData(fromManagedObjectContext: NSManagedObjectContext,searchText : String) -> [SampleNote] {

        var returnedNotes = [SampleNote]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let noteTitleTextPredicate = NSPredicate(format: "noteTitle CONTAINS[c] %@", searchText)
        let noteTextTextPredicate = NSPredicate(format: "noteText CONTAINS[c] %@", searchText)
        let noteTimeStampPredicate = NSPredicate(format: "noteTimeStamp CONTAINS[c] %@", searchText)
        let oRPredicate = NSCompoundPredicate(type: .or, subpredicates: [noteTitleTextPredicate,noteTextTextPredicate,noteTimeStampPredicate])
        
        let sortDescriptor1 = NSSortDescriptor(key: Sort.Date.rawValue, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        
        fetchRequest.predicate = oRPredicate

        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                let noteManagedObjectRead = fetchRequestResult as! NSManagedObject
                returnedNotes.append(SampleNote.init(
                    noteId:        noteManagedObjectRead.value(forKey: "noteId")        as! UUID,
                    noteTitle:     noteManagedObjectRead.value(forKey: "noteTitle")     as! String,
                    noteText:      noteManagedObjectRead.value(forKey: "noteText")      as! String,
                    noteTimeStamp: noteManagedObjectRead.value(forKey: "noteTimeStamp") as! Int64))
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
        }
        
        // set note count
        self.count = returnedNotes.count
        
        return returnedNotes
    }
    
    // Perform List SoryBy Action
    static func readNotesFromCoreData(fromManagedObjectContext: NSManagedObjectContext,sortBy : String, ASC: Bool) -> [SampleNote] {

            var returnedNotes = [SampleNote]()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let sortDescriptor1 = NSSortDescriptor(key: sortBy, ascending: ASC)
        fetchRequest.sortDescriptors = [sortDescriptor1]
            
            do {
                let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
                fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                    let noteManagedObjectRead = fetchRequestResult as! NSManagedObject
                    returnedNotes.append(SampleNote.init(
                        noteId:        noteManagedObjectRead.value(forKey: "noteId")        as! UUID,
                        noteTitle:     noteManagedObjectRead.value(forKey: "noteTitle")     as! String,
                        noteText:      noteManagedObjectRead.value(forKey: "noteText")      as! String,
                        noteTimeStamp: noteManagedObjectRead.value(forKey: "noteTimeStamp") as! Int64))
                }
            } catch let error as NSError {
                // TODO error handling
                print("Could not read. \(error), \(error.userInfo)")
            }
            
            // set note count
            self.count = returnedNotes.count
            
            return returnedNotes
        }
    
    static func readNoteFromCoreData(
        noteIdToBeRead:           UUID,
        fromManagedObjectContext: NSManagedObjectContext) -> SampleNote? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let noteIdPredicate = NSPredicate(format: "noteId = %@", noteIdToBeRead as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            if fetchedNotesFromCoreData.count > 0{
                let noteManagedObjectToBeRead = fetchedNotesFromCoreData[0] as! NSManagedObject
                
                return SampleNote.init(
                    noteId:        noteManagedObjectToBeRead.value(forKey: "noteId")        as! UUID,
                    noteTitle:     noteManagedObjectToBeRead.value(forKey: "noteTitle")     as! String,
                    noteText:      noteManagedObjectToBeRead.value(forKey: "noteText")      as! String,
                    noteTimeStamp: noteManagedObjectToBeRead.value(forKey: "noteTimeStamp") as! Int64)
            }
            else{
                print("Empty records!!!")
                return nil
            }
            
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
            return nil
        }
    }

    static func deleteNoteFromCoreData(
        noteIdToBeDeleted:        UUID,
        fromManagedObjectContext: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let noteIdAsCVarArg: CVarArg = noteIdToBeDeleted as CVarArg
        let noteIdPredicate = NSPredicate(format: "noteId == %@", noteIdAsCVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeDeleted = fetchedNotesFromCoreData[0] as! NSManagedObject
            fromManagedObjectContext.delete(noteManagedObjectToBeDeleted)
            
            do {
                try fromManagedObjectContext.save()
                self.count -= 1
            } catch let error as NSError {
                // TODO error handling
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }

}


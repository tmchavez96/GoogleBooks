//
//  BookDAO.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/9/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation
import CoreData


//bookDAO - data accsess object
//implements singleton
final class BookManager{
    
    static var shared = BookManager()
    private init(){}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //place where all the core entities are stored
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GoogleBooks")
        container.loadPersistentStores { (storeDescrip, err) in
            if let error = err {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    //MARK: load all books
    func load() -> [Book] {
        let fetchRequest = NSFetchRequest<BookStorage>(entityName: "BookStorage")
        var books = [Book]()
        
        do {
            let coreBooks = try context.fetch(fetchRequest)
            coreBooks.forEach({
                let book = Book(coreBook: $0)
                books.append(book)
            })
        } catch {
            print(error.localizedDescription)
        }
        print("returning  \(books.count) books")
        return books
    }
    
    //MARK: save a book
    func saveBook(_ book:Book){
        let entity = NSEntityDescription.entity(forEntityName: "BookStorage", in: context)!
        let coreBook = BookStorage(entity: entity , insertInto: context)
        coreBook.id = book.id
        coreBook.title = book.details.title
        coreBook.author = book.details.authors[0]
        coreBook.desc = book.details.desc
        coreBook.imageURL = book.details.image?.thumbnail 
        coreBook.pageCount = Int64(book.details.pageCount ?? -1)
        coreBook.rating = book.details.rating ?? 0.0
        saveContext() //if you don't save, it doesn't persist
        print("saved \(book.details.title ?? "N/A")")
    }
    
    //MARK: removre a book
    func remove(_ book: Book) {
        //since we have saved the unique id, use that to delete
        let fetchRequest = NSFetchRequest<BookStorage>(entityName: "BookStorage")
        let idPredicate = NSPredicate(format: "id==%@", book.id)
        
        fetchRequest.predicate = idPredicate
        do {
            //use the fetch request to get back cities matching the predicate
            let coreBooks = try context.fetch(fetchRequest)
            if let core = coreBooks.first {
                context.delete(core) //delete the core data object
                print("Deleted City from Core: \(book.details.title)")
            }
            saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: check for a book
    func checkForBook(_ book:Book) -> Bool{
        let fetchRequest = NSFetchRequest<BookStorage>(entityName: "BookStorage")
        let idPredicate = NSPredicate(format: "id==%@", book.id)
        fetchRequest.predicate = idPredicate
        
        do{
            let coreBooks = try context.fetch(fetchRequest)
            if coreBooks.count > 0{
                return true
            }else{
                return false
            }
        }catch{
            print(error.localizedDescription)
        }
        return false
    }
    
    
    //required to save any db changes
    func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

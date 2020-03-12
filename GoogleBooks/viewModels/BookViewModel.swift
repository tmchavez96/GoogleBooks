//
//  BookViewModel.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/15/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation

protocol bookSearcher: class{
    func updateView()
}

class BookViewModel{
    weak var delegate: bookSearcher?
    var searchedBooks:[Book] = [] {
        didSet{
            delegate?.updateView()
        }
    }
    var favBooks:[Book] = [] {
        didSet{
            NotificationCenter.default.post(name: Notification.Name("favoritesUpdated"), object: nil)
        }
    }
    
    //MARK: Getters / Setters
    func getSearchCount() -> Int{
        return searchedBooks.count
    }
    
    func getFavoriteCount() -> Int {
        return favBooks.count
    }
    
    func getSearchBookFromIndex(_ index:Int) -> Book?{
        if(index < searchedBooks.count){
            return searchedBooks[index]
        }else{
            return nil
        }
    }
    
    func getFavBookFromIndex(_ index:Int) -> Book?{
        if(index < favBooks.count){
            return favBooks[index]
        }else{
            return nil
        }
    }
    
    //MARK: Network functions
    func searchBooks(_ query:String){
        httpHandler.shared.searchFor(query) {
            [weak self] result in
            self?.searchedBooks = result
            print("found \(result.count) books")
    
        }
    }
    
    //MARK: Core Data Functions
    func getFavs(){
        favBooks = BookManager.shared.load()
    }
    
    func delBook(book:Book){
        BookManager.shared.remove(book)
        getFavs()
    }
    
    func saveBook(book:Book){
        BookManager.shared.saveBook(book)
        getFavs()
    }
    
    func checkForBook(book:Book) -> Bool{
        return BookManager.shared.checkForBook(book)
    }
    
}

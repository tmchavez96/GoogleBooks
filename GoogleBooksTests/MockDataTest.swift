//
//  MockDataTest.swift
//  GoogleBooksTests
//
//  Created by Taylor Chavez on 3/18/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import XCTest

@testable import GoogleBooks

class MockDataTest: XCTestCase {

    var bookVM:BookViewModel = BookViewModel(isMock: true)
    override func setUp() {
        let bookList = BookManager.shared.load()
        for book in bookList {
            BookManager.shared.remove(book)
        }
               
        bookVM.searchBooks("Oprah")
        sleep(1)
    }

    override func tearDown() {
        let bookList = BookManager.shared.load()
        for book in bookList {
            BookManager.shared.remove(book)
        }
    }

    func testGetSearchCount() {
        let count = bookVM.getSearchCount()
        XCTAssert(count > 0 , "search / search count failed")
    }
    
    func testGetSearchBook(){
        let book = bookVM.getSearchBookFromIndex(0)
        XCTAssertNotNil(book,"get was out of index or nil")
    }
    
    func testGetFavCount(){
        guard let book = bookVM.getSearchBookFromIndex(0) else {return }
        bookVM.saveBook(book:book)
        let countRes = bookVM.getFavoriteCount()
        XCTAssertEqual(countRes, 1,"getFavoriteCount failed")
    }
    
    func testGetFavortieBook(){
        guard let book = bookVM.getSearchBookFromIndex(0) else {return }
        bookVM.saveBook(book:book)
        bookVM.getFavs()
        let favBook = bookVM.getFavBookFromIndex(0)
        XCTAssertNotNil(favBook,"getFavoriteBook failed")
    }
    
    func testSaveAndLoadBook(){
        guard let book = bookVM.getSearchBookFromIndex(0) else {return }
        bookVM.saveBook(book:book)
        bookVM.getFavs()
        XCTAssertEqual(bookVM.getFavoriteCount(), 1,"load or save failed")
    }
    
    
    func testCheckAndDel(){
        guard let book = bookVM.getSearchBookFromIndex(0) else {return }
        bookVM.saveBook(book:book)
        XCTAssert(bookVM.checkForBook(book:book),"1st check failed")
        bookVM.delBook(book:book)
        XCTAssert(!bookVM.checkForBook(book:book),"2nd check failed - delete failed")
    }


}

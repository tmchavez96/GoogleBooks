//
//  GoogleBooksTests.swift
//  GoogleBooksTests
//
//  Created by Taylor Chavez on 3/7/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import XCTest
@testable import GoogleBooks

class GoogleBooksTests: XCTestCase {

    
    var searchVC:UIViewController!
    override func setUp() {
        //clear core data on setup
        let bookList = BookManager.shared.load()
        for book in bookList {
            BookManager.shared.remove(book)
        }
        
        
        //setup view controllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewCont = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchVC = searchViewCont
        _ = searchVC.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUrlService() {
        let testInput = "Harry Potter"
        let encodeStr = UrlService.base + (testInput.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        let url = URL(string: encodeStr)
        let testResult = UrlService.getSearchUrl(testInput)!
        XCTAssertEqual(url,testResult,"Url Service Failer")
    }
    
    func testHttpHandlerSearch(){
        var searchResults:[Book] = []
        let exception = self.expectation(description: "networking")
        httpHandler.shared.searchFor("Harry Potter") { searchRes in
            searchResults = searchRes
            exception.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssert(searchResults.count > 0, "search failed" )
    }
    
    func testHttpHandlerImageTask(){
        let testImageUrl = "https://i.imgur.com/NXW5SEh.jpg"
        var test1Image:UIImage?
        var test2Image:UIImage?
        let exception = self.expectation(description: "networking")
        httpHandler.shared.getImage(testImageUrl) { (result1) in
            test1Image = result1
            exception.fulfill()
        }
        let exception2 = self.expectation(description: "networking again ")
        let badUrl = "gibberish"
        httpHandler.shared.getImage(badUrl) { (result2) in
            test2Image = result2
            exception2.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNotNil(test1Image,"couldn't get image")
        XCTAssertNil(test2Image,"bad request worked?")
    }
    
    
    func testBookManagerSaveAndLoad(){
        let exception = self.expectation(description: "networking")
        var savedBooks:[Book] = []
        httpHandler.shared.searchFor("Harry Potter") { saveResult in
            if(saveResult.count > 0){
                BookManager.shared.saveBook(saveResult[0])
                savedBooks = BookManager.shared.load()
            }
            exception.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssert(savedBooks.count > 0)
    }
    
    func testBookManagerRemoveAndCheck(){
        let exception = self.expectation(description: "networking")
        var checkResult:Bool = false;
        var checkEmptyResult:Bool = false;
        httpHandler.shared.searchFor("Harry Potter") { removeResult in
            if (removeResult.count > 0) {
                BookManager.shared.saveBook(removeResult[0])
                checkResult =  BookManager.shared.checkForBook(removeResult[0])
                BookManager.shared.remove(removeResult[0])
                checkEmptyResult = !BookManager.shared.checkForBook(removeResult[0])
            }
            exception.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssert(checkResult," Saved Book wasn't found")
        XCTAssertNil(checkEmptyResult, "Book found after removal")
    }

}

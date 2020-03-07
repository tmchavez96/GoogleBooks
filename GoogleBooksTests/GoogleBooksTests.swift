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
        XCTAssert(url == testResult)
    }
    
    func testNoResults(){
        let testController:NoResults = NoResults();
        testController.viewDidLoad()
        XCTAssertNotNil(testController)
    }
    
    func testHttpHandlerSearch(){
        httpHandler.shared.searchFor("Harry Potter") { result in
            XCTAssert(result.count > 0)
        }
    }
    
    func testHttpHandlerImageTask(){
        let testImageUrl = "https://i.imgur.com/NXW5SEh.jpg"
        httpHandler.shared.getImage(testImageUrl) { (result) in
            XCTAssertNotNil(result)
        }
        let badUrl = "gibberish"
        httpHandler.shared.getImage(badUrl) { (result) in
            XCTAssertNil(result)
        }
    }
    
    
    func testBookManagerSaveAndLoad(){
        httpHandler.shared.searchFor("Harry Potter") { result in
            BookManager.shared.saveBook(result[0])
            let savedBooks = BookManager.shared.load()
            XCTAssert(savedBooks.count > 0)
        }
    }
    
    func testBookManagerRemoveAndCheck(){
        httpHandler.shared.searchFor("Harry Potter") { result in
            let test1 =  BookManager.shared.checkForBook(result[0])
            XCTAssert(!test1)
            BookManager.shared.remove(result[0])
            let test2 = BookManager.shared.checkForBook(result[0])
            XCTAssert(!test2)
        }
    }

    
    func testSearchController(){
        // do we need to test button pushes and others?
        XCTAssertNotNil(searchVC)
    }

}

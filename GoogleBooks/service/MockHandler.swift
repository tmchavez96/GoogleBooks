//
//  mockHandler.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 3/18/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation


class MockHandler:BookHandler {
    func searchFor(_ search:String, completion: @escaping ([Book]) -> Void){
        let book1 = Book(manualId:"5EABC", title:"Moby Dick",authors:["A Guy"], pageCount:100, desc:"Man VS Giant Whale",rating:4.5,
        imagePath:"nah")
        let book2 = Book(manualId:"5EABD", title:"A Tale of 2 Cities",authors:["Charles Dickens"], pageCount:400, desc:"2 guys, 1 gal, and a the french revolution",rating:4.5,
        imagePath:"nah")
        completion([book1,book2])
    }
}

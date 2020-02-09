//
//  Book.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/8/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation
import CoreData

struct BookResponse: Decodable{
    var totalItems:Int
    var items: [Book]
}

struct Book: Decodable{
    var id: String
    var details: BookDetails
    
    private enum CodingKeys:  String, CodingKey {
        case id
        case details = "volumeInfo"
    }
    
    init(coreBook: BookStorage){
        id = coreBook.id!
        details = BookDetails(coreBook)
    }
}

struct BookDetails: Decodable{
    var title: String?
    var authors: [String]
    var pageCount: Int?
    var desc: String?
    var rating: Double?
    var image: BookImage?
    private enum CodingKeys:  String, CodingKey {
        case title
        case authors
        case pageCount
        case desc = "description"
        case rating = "averageRating"
        case image = "imageLinks"
    }
    init(_ coreBook: BookStorage){
        title = coreBook.title ?? "Title N/A"
        authors = [coreBook.author ?? "Author N/A"]
        pageCount = Int(coreBook.pageCount)
        desc = coreBook.desc
        rating = coreBook.rating
        image = BookImage(coreBook)
    }
}

struct BookImage: Decodable{
    var thumbnail: String
    
    init(_ coreBook: BookStorage){
        thumbnail = coreBook.imageURL ?? ""
    }
}

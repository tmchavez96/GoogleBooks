//
//  Book.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/8/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation
import CoreData

struct BookResponse: Decodable {
    var totalItems: Int
    var items: [Book]
}

struct Book: Decodable {
    var id: String
    var details: BookDetails
    
    private enum CodingKeys: String, CodingKey {
        case id
        case details = "volumeInfo"
    }
    
    init(coreBook: BookStorage) {
        id = coreBook.id!
        details = BookDetails(coreBook)
    }
    init(manualId: String, title: String, authors: [String], pageCount: Int, desc: String, rating: Double,
         imagePath: String) {
        id = manualId
        details = BookDetails(title: title, authors: authors, pageCount: pageCount, desc: desc, rating: rating, imagePath: imagePath)
    }
}

struct BookDetails: Decodable {
    var title: String?
    var authors: [String]
    var pageCount: Int?
    var desc: String?
    var rating: Double?
    var image: BookImage?
    private enum CodingKeys: String, CodingKey {
        case title
        case authors
        case pageCount
        case desc = "description"
        case rating = "averageRating"
        case image = "imageLinks"
    }
    init(_ coreBook: BookStorage) {
        title = coreBook.title ?? "Title N/A"
        authors = [coreBook.author ?? "Author N/A"]
        pageCount = Int(coreBook.pageCount)
        desc = coreBook.desc
        rating = coreBook.rating
        image = BookImage(coreBook)
    }
    init( title: String, authors: [String], pageCount: Int, desc: String, rating: Double,
          imagePath: String) {
        self.title = title
        self.authors = authors
        self.pageCount = pageCount
        self.desc = desc
        self.rating = rating
        self.image = BookImage(imagePath)
    }
}

struct BookImage: Decodable {
    var thumbnail: String
    
    init(_ coreBook: BookStorage) {
        thumbnail = coreBook.imageURL ?? ""
    }
    init(_ imagePath: String) {
        thumbnail = imagePath
    }
}

//
//  UrlService.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/8/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation


class UrlService {
    static var base = "https://www.googleapis.com/books/v1/volumes?q="
    
    
    
    static func getSearchUrl(_ searchStr: String) -> URL? {
        let encodeStr = base + (searchStr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        print(encodeStr)
        let url = URL(string: encodeStr)
        return url
    }
}

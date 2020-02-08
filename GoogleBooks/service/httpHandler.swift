//
//  httpHandler.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/8/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation


final class httpHandler {
    static let shared = httpHandler()
    private init () {}
    
    func searchFor(_ search:String, completion: @escaping ([Book]) -> Void){
        guard let url:URL = UrlService.getSearchUrl(search) else{
            completion([])
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url){ (data,_,err) in
            if let error = err {
                print(error.localizedDescription)
                completion([])
                return
            }
            if let myData = data{
                do{
                    print(myData)
                    let myRes = try JSONDecoder().decode(BookResponse.self, from: myData)
                    print("total items - \(myRes.totalItems)")
                    completion(myRes.items)
                }catch{
                    print(error.localizedDescription)
                }
            }
            completion([])
            return
        }.resume()
    }
}

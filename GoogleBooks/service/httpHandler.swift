//
//  httpHandler.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/8/20.
//  Copyright © 2020 T
import UIKit

final class httpHandler:BookHandler {
    static let shared = httpHandler()
    private init () {}
    
    
    //MARK: Search the google api
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
                    return
                }catch{
                    print(error.localizedDescription)
                }
            }
            completion([])
            return
        }.resume()
    }
    
    //MARK: get an image
    func getImage(_ imageUrl:String, completion: @escaping (UIImage?) -> Void){
        guard let url:URL = URL(string: imageUrl) else{
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url){ (data,_,err) in
            if let error = err {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            if let myData = data {
                let image = UIImage(data: myData)
                DispatchQueue.main.async{
                   completion(image)
                }
                return
            }
            
        }.resume()
    }
}

//
//  viewModel.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/8/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation


class viewModel {
    var Books:[Book]
    
    init(){
        Books = []
    }
    
    
    func getBooks(_ search:String){
        httpHandler.shared.searchFor(search) {
            [weak self] result in
            self?.Books = result
            print("found \(result.count) books")
        }
    }
}

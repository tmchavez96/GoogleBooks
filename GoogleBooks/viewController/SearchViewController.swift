//
//  ViewController.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/8/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var Books:[Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        httpHandler.shared.searchFor("Harry Potter") {
            [weak self] result in
            self?.Books = result
            print("found \(result.count) books")
            self?.printBooks()
        }
    }
    
    func printBooks(){
        for cur in Books{
            print("book name - \(cur.details.title)")
        }
    }

}


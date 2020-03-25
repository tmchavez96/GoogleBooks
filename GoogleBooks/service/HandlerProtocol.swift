//
//  HandlerProtocol.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 3/18/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import Foundation

protocol BookHandler {
     func searchFor(_ search: String, completion: @escaping ([Book]) -> Void)
}

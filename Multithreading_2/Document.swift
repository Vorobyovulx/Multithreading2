//
//  Document.swift
//  Multithreading_2
//
//  Created by Mad Brains on 17.09.2020.
//  Copyright © 2020 GeekTest. All rights reserved.
//

import Foundation

// CustomStringConvertible - все типы, которые удволетворяют этому протоколу, смогут отображать свое содержимое в кач-ве строки
struct Document: CustomStringConvertible {
    
    let id: Int
    let name: String
    
    var description: String {
        return "\(id) - \(name)"
    }
    
}

//
//  DocumentsViewController.swift
//  Multithreading_2
//
//  Created by Mad Brains on 17.09.2020.
//  Copyright © 2020 GeekTest. All rights reserved.
//

import Foundation
import UIKit

class DocumentsViewController: UIViewController {
    
    var documents = [Document]()
    
    var documentsStore = DocumentsSafetyStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstChar = UnicodeScalar("А").value
        let lastChar = UnicodeScalar("Я").value
        let dispatchGroup = DispatchGroup()
        
        for charCode in firstChar...lastChar {
            DispatchQueue.global().async(group: dispatchGroup) {
                let docName = String(UnicodeScalar(charCode)!)
                self.documentsStore.createDocument(name: docName)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print(self.documentsStore)
        }
    }
    
}

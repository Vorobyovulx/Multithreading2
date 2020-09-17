//
//  DocumentsSafetyStore.swift
//  Multithreading_2
//
//  Created by Mad Brains on 17.09.2020.
//  Copyright © 2020 GeekTest. All rights reserved.
//

import Foundation

class DocumentsSafetyStore: CustomStringConvertible {
    
    var description: String {
        var tempDescription = ""
        
        syncQueue.sync {
            tempDescription = self.documents.reduce("") {
                $0 + $1.description + ", "
            }
        }
        
        return tempDescription
    }
    
    private var documents = [Document]()
    private var syncQueue = DispatchQueue(label: "DocumentStoreSyncQueue", attributes: .concurrent)
    
    func getDocument(byId id: Int) -> Document? {
        var document: Document?
        
        syncQueue.sync {
            document = documents.filter {
                $0.id == id
            }.first
        }

        return document
    }
    
    func getLastDocument() -> Document? {
        var document: Document?
        
        syncQueue.sync {
            document = documents.last
        }

        return document
    }
    
    func appendDocument(document: Document) {
        syncQueue.async(flags: .barrier) {
            self.documents.append(document)
        }
    }
    
    func createDocument(name: String) {
        syncQueue.async(flags: .barrier) {
            let lastId = self.documents.last?.id ?? 0
            let newId = lastId + 1
            let doc = Document(id: newId, name: name)
            
            self.documents.append(doc)
        }
    }
    
}

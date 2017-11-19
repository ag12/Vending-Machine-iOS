//
//  PlistConverter.swift
//  VendingMachine
//
//  Created by Amir Ghoreshi on 16/11/2017.
//

import Foundation

enum InventoryError: Error {
    case invalidResource
    case invalidSelection
    case conversionFailure
}

class PlistConverter {
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String : AnyObject] {
        
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw InventoryError.invalidResource
        }
        
        guard let dictionary = NSDictionary (contentsOfFile: path) as? [String : AnyObject] else {
            throw InventoryError.conversionFailure
        }
        
        return dictionary;
    }
}

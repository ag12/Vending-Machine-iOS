//
//  InventoryUnarchiver.swift
//  VendingMachine
//
//  Created by Amir Ghoreshi on 19/11/2017.
//

import Foundation

class InventoryUnarchiver {
    static func vendingInventory(fromDictionary dictionary: [String : AnyObject]) throws -> [VendingSelection : VendingItem] {
        
        var inventory: [VendingSelection : VendingItem] = [:]
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any], let price = itemDictionary["price"] as? Double, let quantity = itemDictionary["quantity"] as? Int {
                let item = Item(price: price, quantity: quantity)
                
                guard let selection = VendingSelection(rawValue: key) else {
                    throw InventoryError.invalidSelection
                }
                
                inventory.updateValue(item, forKey: selection)
            }
        }
        
        return inventory
    }
}

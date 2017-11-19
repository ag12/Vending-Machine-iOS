//
//  ViewController.swift
//  VendingMachine
//
//  Created by Pasan Premaratne on 12/1/16.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "vendingItem"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    let vendingMachine: VendingMachine
    var currentSelection: VendingSelection?
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "VendingInventory", ofType: "plist")
            let inventory = try InventoryUnarchiver.vendingInventory(fromDictionary: dictionary)
            
            vendingMachine = FoodVendingMachine(inventory: inventory)
            
        } catch InventoryError.invalidSelection {
            vendingMachine = FoodVendingMachine(inventory: [:])

        } catch InventoryError.invalidResource {
            vendingMachine = FoodVendingMachine(inventory: [:])

        } catch InventoryError.conversionFailure {
            vendingMachine = FoodVendingMachine(inventory: [:])

        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = CollectionViewHelpKit.setupCollectionView()
        updateDisplayWith(balance: vendingMachine.amountDeposited, itemPrice:0, itemQuantity:1,  totalPrice:0.0)
    }

    // MARK: - Action
    
    @IBAction func purchase() {
        purchaseItem()
    }
    
    @IBAction func updateQuantity(_ sender: UIStepper) {
        updateDisplayWith(itemQuantity: Int(sender.value))
    
        if let currentSelection = currentSelection, let item = vendingMachine.item(forSelection: currentSelection) {
            updatePrice(for: item)
        }
    }
    
    
    func purchaseItem() -> () {
        
        if let currentSelection = currentSelection {
            do {
                try vendingMachine.vend(selection: currentSelection, quantity: Int(quantityStepper.value))
                updateDisplayWith(balance: vendingMachine.amountDeposited, itemPrice:0, itemQuantity:1,  totalPrice:0.0)
            } catch {
                print("\(error)")
            }
            
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                collectionView.deselectItem(at: indexPath, animated: true)
                updateCell(having: indexPath, selected: false)
            }
            
        } else {
            // FIXME: Alert user to no selection
        }
    }
    
    
    // MARK: - Vending Machine
    
    func updateDisplayWith(balance: Double? = nil, itemPrice: Double? = nil, itemQuantity: Int? = nil, totalPrice: Double? = nil) -> () {
        
        if let balanceValue = balance {
            balanceLabel.text = "$\(balanceValue)"
        }

        if let totalPriceValue = totalPrice {
            totalLabel.text = "$\(totalPriceValue)"
        }
        
        if let itemPriceValue = itemPrice {
            priceLabel.text = "$\(itemPriceValue)"
        }
        
        if let itemQuantityValue = itemQuantity {
            quantityLabel.text = "\(Int(itemQuantityValue))"
        }
        
    }
    
    func updatePrice(for item: VendingItem) -> () {
        let totalPrice = item.price * Double(quantityStepper.value)
        updateDisplayWith(totalPrice: totalPrice)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vendingMachine.selection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? VendingItemCell else { fatalError() }
        
        let item = vendingMachine.selection[indexPath.row]
        cell.iconView.image = item.icon()
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: true)
        
        quantityStepper.value = 1
        updateDisplayWith(itemQuantity: 1, totalPrice: 0)
        
        
        currentSelection = vendingMachine.selection[indexPath.row]
        
        if let currentSelection = currentSelection, let item = vendingMachine.item(forSelection: currentSelection) {
            
            updateDisplayWith(itemPrice: item.price, totalPrice: item.price * Double(quantityStepper.value))

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: false)

    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: false)

    }
    
    func updateCell(having indexPath: IndexPath, selected: Bool) {
        
        let selectedBackgroundColor = UIColor(red: 41/255.0, green: 211/255.0, blue: 241/255.0, alpha: 1.0)
        let defaultBackgroundColor = UIColor(red: 27/255.0, green: 32/255.0, blue: 36/255.0, alpha: 1.0)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = selected ? selectedBackgroundColor : defaultBackgroundColor
        }
    }
}

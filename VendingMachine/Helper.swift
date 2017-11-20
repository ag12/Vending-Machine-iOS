//
//  Helper.swift
//  VendingMachine
//
//  Created by Amir Ghoreshi on 19/11/2017.
//

import UIKit

struct CollectionViewHelpKit {
    
    static func setupCollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        let screenWidth = UIScreen.main.bounds.width
        
        let padding: CGFloat = 10
        let itemWidth = screenWidth/3 - padding
        let itemHeight = screenWidth/3 - padding
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        return layout
    }
}

struct AlertControllerHelpKit {
    
    static func alertController(title: String, message: String, handler: @escaping (UIAlertAction) -> Void ) -> UIAlertController {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        return alertController
        
    }
}

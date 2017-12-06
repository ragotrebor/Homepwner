//
//  ItemStore.swift
//  Homepwner
//
//  Created by Roberto García on 05-12-17.
//  Copyright © 2017 Roberto García. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    init(){
        for _ in 0..<5 {
            createItem()
        }
    }

}



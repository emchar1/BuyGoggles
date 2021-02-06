//
//  Constants.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/15/20.
//

import UIKit

struct K {
//    static let columnVendorNo = 1
//    static let columnSKU = 2
//    static let columnCategory = 3
//    static let columnBrand = 4
//    static let columnDescription = 5
//    static let columnUnitPrice = 6
//    static let columnQty = 7

    static let lowStock = 100
    static let maxQty = 999
    
    static var items: [ItemModel] = []
    static var brands: [String] = []
    static var shoppingCart: [ItemModel] {
        return items.filter { ($0.qtyOrdered != nil && $0.qtyOrdered! > 0) }
    }
    static var orderedBrands: [String] {
        var brands: [String] = []
        
        for item in shoppingCart {
            if !brands.contains(item.brand) {
                brands.append(item.brand)
            }
        }
        
        return brands
    }
}


extension CGPoint {
    func isOutside(of rect: CGRect) -> Bool {
        return self.x < rect.origin.x || self.x > rect.width || self.y < rect.origin.y || self.y > rect.height
    }
}

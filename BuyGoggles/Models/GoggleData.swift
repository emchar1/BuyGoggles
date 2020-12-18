//
//  GoggleData.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/13/20.
//

import UIKit

struct GoggleData: Comparable {
    var brand: String
    var vendorNo: String
    var sku: String
    var description: String
    var image: UIImage
    var qty: Int
    var qtyOrdered: Int?
    
    static func < (lhs: GoggleData, rhs: GoggleData) -> Bool {
        //First sort
        if lhs.brand != rhs.brand {
            return lhs.brand < rhs.brand
        }
        
        //Second sort
        return lhs.sku < rhs.sku
    }
}

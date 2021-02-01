//
//  GoggleData.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/13/20.
//

import UIKit
import FirebaseStorage

struct GoggleData: Comparable {
    var vendorNo: String
    var sku: Int64
    var category: String
    var brand: String
    var description: String
    var unitPrice: Float
    var qty: Int
    var qtyOrdered: Int?
    var image: StorageReference

    static func < (lhs: GoggleData, rhs: GoggleData) -> Bool {
        //First sort
        if lhs.brand != rhs.brand {
            return lhs.brand < rhs.brand
        }
        
        //Second sort
        return lhs.sku < rhs.sku
    }
}

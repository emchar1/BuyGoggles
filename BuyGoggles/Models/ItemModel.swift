//
//  ItemModel.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/13/20.
//

import UIKit
import FirebaseStorage

struct ItemModel: Comparable {
    var vendorNo: String
    var TRSku: Int64
    var PUSku: Int64
    var category: String
    var brand: String
    var description: String
    var unitPrice: Float
    var TRQty: Int
    var PUQty: Int
    var qtyOrdered: Int?
    var imageURL: String                    //may be ""
    var image: StorageReference

    static func < (lhs: ItemModel, rhs: ItemModel) -> Bool {
        //First sort
        if lhs.brand != rhs.brand {
            return lhs.brand < rhs.brand
        }
        
        //Second sort
        return lhs.TRSku < rhs.TRSku
    }
}

//
//  Constants.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/15/20.
//

import UIKit

struct K {
    static let columnVendorNo = 1
    static let columnSKU = 2
    static let columnCategory = 3
    static let columnBrand = 4
    static let columnDescription = 5
    static let columnQty = 6

    static let lowStock = 100
    static let maxQty = 9999

    static var goggleData: [GoggleData] = []
    static var goggleBrands: [String] = []
}

extension CGPoint {
    func isOutside(of rect: CGRect) -> Bool {
        return self.x < rect.origin.x || self.x > rect.width || self.y < rect.origin.y || self.y > rect.height
    }
}

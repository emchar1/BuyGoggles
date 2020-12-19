//
//  FooterView.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/15/20.
//

import UIKit

class FooterView: UICollectionReusableView {
    static let reuseIdentifier = "FooterID"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        return label
    }()
    
    func configure() {
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
    }
}

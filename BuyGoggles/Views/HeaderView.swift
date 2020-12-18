//
//  HeaderView.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/15/20.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderID"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "HEADER"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "Avenir Next Condensed Demi Bold Italic", size: 32)
        return label
    }()
    
    func configure() {
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Makes the frame the entirety of the header view. Neat!
        label.frame = bounds
        
        label.frame.origin.x = CustomCell.padding
    }
}

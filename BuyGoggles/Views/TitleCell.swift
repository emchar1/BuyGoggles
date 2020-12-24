//
//  TitleCell.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/24/20.
//

import UIKit

class TitleCell: UICollectionViewCell {
    static let identifier = "CVTitleCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = UIView(frame: frame)
        view.backgroundColor = .magenta
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

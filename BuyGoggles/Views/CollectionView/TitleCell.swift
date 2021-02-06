//
//  TitleCell.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/24/20.
//

import UIKit

class TitleCell: UICollectionViewCell {
    static let identifier = "CVTitleCell"
    let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        addSubview(view)
        
        let itemImageView = UIImageView(frame: view.frame)
        itemImageView.image = UIImage(named: "goggles.png")
        itemImageView.alpha = 0.5
        view.addSubview(itemImageView)
        
        let titleLabel = UILabel()
//        titleLabel.text = "100PRCNT®\nTUCKER POWERSPORTS\nMX COLLECTION\nGOGGLES"
        titleLabel.text = "Buy 100%"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Baskerville", size: 26)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

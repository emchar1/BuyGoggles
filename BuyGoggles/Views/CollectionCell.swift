//
//  CollectionCell.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/13/20.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CVCell"
    static let padding: CGFloat = 8
    static let widthImageView: CGFloat = UIScreen.main.bounds.width / 3 - padding * 1.5
    static let heightImageView: CGFloat = widthImageView * 0.465
    static let heightDescriptionLabel: CGFloat = 40
    static let heightStack: CGFloat = heightImageView + heightDescriptionLabel
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var skuLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Condensed Regular", size: 12.0)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        let vStack = UIStackView(arrangedSubviews: [imageView, skuLabel])
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(vStack)

        NSLayoutConstraint.activate([vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     contentView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor),
                                     contentView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor)])
        
        NSLayoutConstraint.activate([imageView.heightAnchor.constraint(equalToConstant: CollectionCell.heightImageView),
                                     skuLabel.heightAnchor.constraint(equalToConstant: CollectionCell.heightDescriptionLabel)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}

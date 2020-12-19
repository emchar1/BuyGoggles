//
//  TableViewCell.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/19/20.
//

import UIKit


// MARK: - TableLabel

class TableLabel: UILabel {
    let labelFont = UIFont(name: "Avenir Next Condensed Regular", size: 14)

    init(text: String, textAlignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        
        self.font = labelFont
        self.text = text
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - TableViewCell

class TableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TVCell"
    let padding: CGFloat = 8
    let skuLabel = TableLabel(text: "999999")
    let itemDescLabel = TableLabel(text: "SAMPLE GOGGLE ITEM DESCRIPTION")
    let qtyLabel = TableLabel(text: "9999", textAlignment: .right)
    let totalCost = TableLabel(text: "$99,999.99", textAlignment: .right)
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(skuLabel)
        contentView.addSubview(itemDescLabel)
        contentView.addSubview(qtyLabel)
        contentView.addSubview(totalCost)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Customization
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        skuLabel.frame = CGRect(x: padding,
                                y: padding,
                                width: 50,
                                height: contentView.frame.height - padding * 2)
        
        itemDescLabel.frame = CGRect(x: padding + skuLabel.frame.width,
                                     y: padding,
                                     width: contentView.frame.width - (50 + 50 + 75 + 1 * padding),
                                     height: contentView.frame.height - padding * 2)
        
        qtyLabel.frame = CGRect(x: contentView.frame.width - (50 + 75 + padding),
                                y: padding,
                                width: 50,
                                height: contentView.frame.height - padding * 2)
        
        totalCost.frame = CGRect(x: contentView.frame.width - 75 - padding,
                                 y: padding,
                                 width: 75,
                                 height: contentView.frame.height - padding * 2)
    }
    
//    override func prepareForReuse() {
//        skuLabel.text = ""
//        itemDescLabel.text = ""
//    }
//
//    func configure(sku: String, itemDesc: String) {
//        skuLabel.text = sku
//        itemDescLabel.text = itemDesc
//    }
}

//
//  HamburgerMenu.swift
//  BuyGoggles
//
//  Created by Eddie Char on 11/20/21.
//

import UIKit

class HamburgerMenu: UIView {
    
    // MARK: - Properties
    
    private let collapsedSize: CGFloat = 8
    private let collapsedTransparency: CGFloat = 0.25
    private var hamburgerTrailingAnchor: NSLayoutConstraint!
    
    private var hamburgerMenuIsCollapsed = false {
        willSet {
            hamburgerTrailingAnchor.constant = hamburgerMenuIsCollapsed ? frame.width - collapsedSize : 0

            guard let superview = superview else { return }

            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                superview.layoutIfNeeded()
                self.alpha = self.hamburgerMenuIsCollapsed ? self.collapsedTransparency : 1
            }, completion: nil)
        }
    }
    
    private var collapseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didPressHamburger(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 8
        backgroundColor = .cyan
        alpha = collapsedTransparency

        addSubview(collapseButton)
        NSLayoutConstraint.activate([collapseButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                                     trailingAnchor.constraint(equalTo: collapseButton.trailingAnchor),
                                     collapseButton.widthAnchor.constraint(equalToConstant: 40),
                                     collapseButton.heightAnchor.constraint(equalToConstant: 40)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    
    func setConstraints() {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        hamburgerTrailingAnchor = superview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: superview.frame.width - collapsedSize)
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: superview.topAnchor),
                                     hamburgerTrailingAnchor,
                                     superview.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     widthAnchor.constraint(equalTo: superview.widthAnchor)])
    }
    
    @objc private func didPressHamburger(_ sender: UIButton) {
        hamburgerMenuIsCollapsed = !hamburgerMenuIsCollapsed
    }
}

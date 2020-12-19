//
//  GoggleDetailController.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/15/20.
//

import UIKit

protocol GoggleDetailControllerDelegate {
    func goggleDetailController(_ controller: GoggleDetailController, didUpdateQty qtyOrdered: Int, forVendorNo vendorNo: String)
}

class GoggleDetailController: UIViewController {
    let padding: CGFloat = 20
    var vendorNo: String!
    var image: UIImage!
    var brand: String!
    var itemDescription: String!
    var qtyAvailable: Int = 0
    var qtyOrdered: Int?
    
    var textField: UITextField!
    
    var delegate: GoggleDetailControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        let brandLabel = UILabel()
        brandLabel.font = UIFont(name: "Avenir Next Condensed Demi Bold Italic", size: 32)
        brandLabel.text = brand
        brandLabel.textAlignment = .center
        brandLabel.textColor = .white
        brandLabel.backgroundColor = .black
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brandLabel)
        NSLayoutConstraint.activate([brandLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
                                     brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: brandLabel.trailingAnchor),
                                     brandLabel.heightAnchor.constraint(equalToConstant: 60)])

        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: padding),
                                     imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     imageView.widthAnchor.constraint(equalToConstant: CollectionCell.widthImageView * 2),
                                     imageView.heightAnchor.constraint(equalToConstant: CollectionCell.heightImageView * 2)])
                
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont(name: "Avenir Next Condensed Regular", size: 14)
        descriptionLabel.text = itemDescription
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
                                     descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
                                     descriptionLabel.heightAnchor.constraint(equalToConstant: 20)])
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Avenir Next Condensed Regular", size: 14)!,
                                                         .foregroundColor: UIColor.gray]
        textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: hasStock() ? "Enter qty" : "Out of Stock", attributes: attributes)
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.textAlignment = .center
        textField.isEnabled = hasStock() ? true : false
        textField.text = qtyOrdered != nil ? "\(qtyOrdered!)" : ""
        textField.becomeFirstResponder()
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        NSLayoutConstraint.activate([textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding * 2),
                                     textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     textField.widthAnchor.constraint(equalToConstant: 75)])
        
        let saveButton = UIButton(type: .system)
        saveButton.backgroundColor = .black
        saveButton.setTitle(hasStock() ? (qtyOrdered != nil ? "Update Cart" : "Add to Cart") : "Go Back", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 18)
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: padding * 2),
                                     saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     saveButton.widthAnchor.constraint(equalToConstant: 150),
                                     saveButton.heightAnchor.constraint(equalToConstant: 60)])
        
        let qtyLabel = UILabel()
        qtyLabel.font = UIFont(name: "Avenir Next Condensed Italic", size: 12)
        qtyLabel.textColor = .gray
        qtyLabel.textAlignment = .center
        qtyLabel.text = "Available qty: \(qtyAvailable)"
        qtyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qtyLabel)
        NSLayoutConstraint.activate([qtyLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: padding),
                                     qtyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     qtyLabel.widthAnchor.constraint(equalToConstant: 200),
                                     qtyLabel.heightAnchor.constraint(equalToConstant: 20)])

    }

    func hasStock() -> Bool {
        return qtyAvailable > 0
    }

    @objc func saveItem(_ sender: UIButton) {
        guard hasStock() else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if let qtyEnteredInt = Int(textField.text!),
           qtyEnteredInt > K.maxQty {
            
            let alert = UIAlertController(title: "Error", message: "To save your order, enter a valid qty between 0 and \(K.maxQty), or swipe down to cancel and return to the list.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
        else {
            delegate?.goggleDetailController(self,
                                             didUpdateQty: Int(textField.text!) ?? 0,
                                             forVendorNo: self.vendorNo)
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func didTapScreen(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)

        if tapLocation.isOutside(of: textField.bounds) {
            textField.endEditing(true)
        }
    }
}

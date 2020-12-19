//
//  CheckoutController.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/17/20.
//

import UIKit

class CheckoutController: UIViewController {
    
    // MARK: - Properties
    
    let cellHeight: CGFloat = 30
    let padding: CGFloat = 8
    let tvPadding: CGFloat = 200
    var scrollHeight: CGFloat {
        guard let tableView = tableView else {
            return 0
        }
        
        return tableView.contentSize.height + 2.5 * tvPadding
    }
    
    let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Your shopping cart is empty."
        label.font = UIFont(name: "Avenir Next Condensed Regular", size: 14)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    var scrollView: UIScrollView!
    var tableView: UITableView!
    let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Checkout", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 18)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.addTarget(self, action: #selector(checkoutPressed), for: .touchUpInside)
        return button
    }()


    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: view.frame.width,
                                                height: view.frame.height))
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollHeight)
        view.addSubview(scrollView)

        tableView = UITableView(frame: CGRect(x: padding,
                                              y: tvPadding,
                                              width: scrollView.frame.width - 2 * padding,
                                              height: 0))
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        scrollView.addSubview(tableView)

        emptyCartLabel.frame = CGRect(x: 0, y: tvPadding, width: scrollView.frame.width, height: cellHeight)
        scrollView.addSubview(emptyCartLabel)
        scrollView.addSubview(checkoutButton)
    }

    //Need to reload the tableView in a separate method!!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    //Use this to resize the views
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        emptyCartLabel.isHidden = K.shoppingCart.isEmpty ? false : true
        checkoutButton.isHidden = K.shoppingCart.isEmpty ? true : false

        //Resize the tableView height to its content size.
        tableView.frame.size.height = tableView.contentSize.height
        scrollView.contentSize.height = scrollHeight
        
        checkoutButton.frame = CGRect(x: scrollView.frame.width / 2 - 75,
                                      y: max(view.frame.height - tvPadding, scrollHeight - tvPadding),
                                      width: 150,
                                      height: 60)
    }
    
    
    // MARK: - Checkout
    
    @objc func checkoutPressed(_ sender: UIButton) {
        print("Checkout!")
    }
}


// MARK: - TableViewDelegate & DataSource

extension CheckoutController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gogglesForBrand = K.shoppingCart.filter { $0.brand == K.orderedBrands[section] }
        
        return gogglesForBrand.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gogglesForBrand = K.shoppingCart.filter { $0.brand == K.orderedBrands[indexPath.section] }
        let formatter = NumberFormatter()

        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        cell.skuLabel.text = gogglesForBrand[indexPath.row].sku
        cell.itemDescLabel.text = gogglesForBrand[indexPath.row].description

        formatter.numberStyle = .decimal
        cell.qtyLabel.text = formatter.string(from: NSNumber(value: gogglesForBrand[indexPath.row].qtyOrdered!))

        formatter.numberStyle = .currency
        cell.totalCost.text = formatter.string(from: NSNumber(value: Float(gogglesForBrand[indexPath.row].qtyOrdered!) * gogglesForBrand[indexPath.row].unitPrice))

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return K.orderedBrands.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: cellHeight))
        let label = UILabel(frame: view.frame)
        label.text = K.orderedBrands[section]
        label.font = UIFont(name: "Avenir Next Condensed Demi Bold Italic", size: 18)
        view.addSubview(label)

        return view
    }
    
    //Use viewForHeaderInSection or titleForHeaderInSection, but not both
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return K.orderedBrands[section]
//    }
}

//
//  CheckoutController.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/17/20.
//

import UIKit
import MessageUI

class CheckoutController: UIViewController {
    
    // MARK: - Properties
    
    let cellHeight: CGFloat = 30
    let padding: CGFloat = 8
    let tvPadding: CGFloat = 40
    var scrollHeight: CGFloat {
        guard let tableView = tableView else {
            return 0
        }
        
        return tableView.contentSize.height + 10 * tvPadding
    }
    
    let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Your shopping cart is empty."
        label.font = UIFont(name: "Avenir Next Condensed Regular", size: 18)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    var scrollView: UIScrollView!
    var tableView: UITableView!
    let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit Order", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 18)
        button.backgroundColor = UIColor(named: "colorButton")
        button.tintColor = UIColor(named: "colorButtonText")
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(checkoutButton)
        
        NSLayoutConstraint.activate([checkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     view.bottomAnchor.constraint(equalTo: checkoutButton.bottomAnchor, constant: 40),
                                     checkoutButton.widthAnchor.constraint(equalToConstant: 150),
                                     checkoutButton.heightAnchor.constraint(equalToConstant: 60)])
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo.svg")?.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = .black
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
        navigationItem.titleView?.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
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
        tableView.isHidden = K.shoppingCart.isEmpty ? true : false
        checkoutButton.isHidden = K.shoppingCart.isEmpty ? true : false

        //Resize the tableView height to its content size.
        tableView.frame.size.height = tableView.contentSize.height
        scrollView.contentSize.height = scrollHeight
    }
}


// MARK: - TableViewDelegate & DataSource

extension CheckoutController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < K.orderedBrands.count else {
            return 1
        }
        
        let gogglesForBrand = K.shoppingCart.filter { $0.brand == K.orderedBrands[section] }
        
        return gogglesForBrand.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = NumberFormatter()

        guard indexPath.section < K.orderedBrands.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
            let sharedFont = UIFont(name: "Avenir Next Condensed Demi Bold", size: 14)
            
            var totalQty: Int = 0
            var totalAmt: Float = 0
            
            for item in K.shoppingCart {
                totalQty += item.qtyOrdered!
                totalAmt += Float(item.qtyOrdered!) * item.unitPrice
            }
            
            cell.skuLabel.text = ""
            cell.itemDescLabel.font = sharedFont
            cell.itemDescLabel.text = "TOTAL ITEMS"

            formatter.numberStyle = .decimal
            cell.qtyLabel.font = sharedFont
            cell.qtyLabel.text = formatter.string(from: NSNumber(value: totalQty))
            
            formatter.numberStyle = .currency
            cell.totalCost.font = sharedFont
            cell.totalCost.text = formatter.string(from: NSNumber(value: totalAmt))
            
            return cell
        }
        
        let gogglesForBrand = K.shoppingCart.filter { $0.brand == K.orderedBrands[indexPath.section] }
        let sharedFont = UIFont(name: "Avenir Next Condensed Regular", size: 14)
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell

        cell.skuLabel.text = gogglesForBrand[indexPath.row].sku
        cell.itemDescLabel.font = sharedFont
        cell.itemDescLabel.text = gogglesForBrand[indexPath.row].description

        formatter.numberStyle = .decimal
        cell.qtyLabel.font = sharedFont
        cell.qtyLabel.text = formatter.string(from: NSNumber(value: gogglesForBrand[indexPath.row].qtyOrdered!))

        formatter.numberStyle = .currency
        cell.totalCost.font = sharedFont
        cell.totalCost.text = formatter.string(from: NSNumber(value: Float(gogglesForBrand[indexPath.row].qtyOrdered!) * gogglesForBrand[indexPath.row].unitPrice))

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return K.orderedBrands.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section < K.orderedBrands.count else {
            return 0
        }
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < K.orderedBrands.count else {
            return nil
        }
        
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


// MARK: - Checkout

extension CheckoutController: MFMailComposeViewControllerDelegate {

    @objc func checkoutPressed(_ sender: UIButton) {
        var csvItems: [[String]] = [["BRAND", "VENDOR NO", "TR SKU", "ITEM DESCRIPTION", "QTY ORDERED", "UNIT PRICE", "TOTAL COST"]]
        
        for item in K.shoppingCart {
            let totalCost: Float = Float(item.qtyOrdered!) * item.unitPrice
            let csvItem: [String] = [item.brand, item.vendorNo, item.sku, item.description, String(item.qtyOrdered!), String(item.unitPrice), String(totalCost)]
            
            csvItems.append(csvItem)
        }
        
        mailOrder(for: CreateCSV.commaSeparatedValueDataForLines(lines: csvItems))
    }
    
    func mailOrder(for data: Data) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Unable to export from Simulator. Try it on a device.")
            return
        }

        
        let mail = MFMailComposeViewController()
        let date = Date()
        let orderNo: Int = 10001
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy h:mm a"

        mail.mailComposeDelegate = self
        mail.setToRecipients(["grady@100percent.com"])
        mail.setSubject("TR Goggle Order #\(orderNo) - \(formatter.string(from: date))")
        mail.setMessageBody("Make it rain.", isHTML: true)
        mail.addAttachmentData(data, mimeType: "text/csv", fileName: "TRGoggle\(orderNo).csv")
        
        present(mail, animated: true)
    }
    
    //This is required to dismiss the mail controller!
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

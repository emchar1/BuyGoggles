//
//  BuyGogglesController.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/12/20.
//

import UIKit

class BuyGogglesController: UIViewController {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "CVCell"
    var orderIndexPath: IndexPath?
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: CustomCell.padding,
                                           left: CustomCell.padding,
                                           bottom: CustomCell.padding,
                                           right: CustomCell.padding)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        cv.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.reuseIdentifier)
        return cv
    }()
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)])
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension BuyGogglesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: CustomCell.widthImageView, height: CustomCell.heightStack)
    }
}


// MARK: - UICollectionViewDataSource

extension BuyGogglesController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return K.goggleBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let goggleForBrand = K.goggleData.filter { $0.brand == K.goggleBrands[section] }
        
        return goggleForBrand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BuyGogglesController.reuseIdentifier, for: indexPath) as! CustomCell
        
        cell.backgroundColor = .white
        
        let goggleForBrand = K.goggleData.filter { $0.brand == K.goggleBrands[indexPath.section] }
        cell.imageView.image = goggleForBrand[indexPath.row].image
        cell.skuLabel.text = goggleForBrand[indexPath.row].sku + (goggleForBrand[indexPath.row].qty <= K.lowStock ? (goggleForBrand[indexPath.row].qty <= 0 ? " - OUT OF STOCK" : " - LOW STOCK") : "") + "\n" + (goggleForBrand[indexPath.row].qtyOrdered != nil ? "Ordered: \(goggleForBrand[indexPath.row].qtyOrdered!)" : "")
        
        if goggleForBrand[indexPath.row].qtyOrdered != nil {
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.green.cgColor
        }
        else {
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: HeaderView.reuseIdentifier,
                                                                         for: indexPath) as! HeaderView
            header.label.text = K.goggleBrands[indexPath.section]
            header.configure()
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                         withReuseIdentifier: FooterView.reuseIdentifier,
                                                                         for: indexPath) as! FooterView
            footer.configure()
            return footer
        default:
            return UICollectionReusableView()
        }
    }
}
    
    
// MARK: - UICollectionViewDelegate

extension BuyGogglesController: UICollectionViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destination as! GoggleDetailController
            
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let goggleForBrand = K.goggleData.filter { $0.brand == K.goggleBrands[indexPath.section] }
                
                controller.vendorNo = goggleForBrand[indexPath.row].vendorNo
                controller.brand = goggleForBrand[indexPath.row].brand
                controller.image = goggleForBrand[indexPath.row].image
                controller.itemDescription = goggleForBrand[indexPath.row].sku + " - " + goggleForBrand[indexPath.row].description
                controller.qtyAvailable = goggleForBrand[indexPath.row].qty
                controller.qtyOrdered = goggleForBrand[indexPath.row].qtyOrdered
                
                //Not sure about theses.....
                controller.delegate = self
                orderIndexPath = indexPath
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 40)
    }
}


// MARK: - GoggleDetailControllerDelegate

extension BuyGogglesController: GoggleDetailControllerDelegate {
    func goggleDetailController(_ controller: GoggleDetailController, didUpdateQty qtyOrdered: Int, forVendorNo vendorNo: String) {

//        K.goggleData.first(where: { $0.vendorNo == vendorNo })?.qtyOrdered = qty
//        K.goggleData.filter { $0.vendorNo == vendorNo }.first?.qtyOrdered = qty

        //don't like this. Try something like above
        for (i, data) in K.goggleData.enumerated() {
            if data.vendorNo == vendorNo {
                K.goggleData[i].qtyOrdered = qtyOrdered == 0 ? nil : qtyOrdered
            }
        }
        
        collectionView.reloadData()
    }
    
}

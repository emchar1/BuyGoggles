//
//  BuyGogglesController.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/12/20.
//

import UIKit
import Firebase
import FirebaseUI

class BuyGogglesController: UIViewController {
    
    // MARK: - Properties
    var orderIndexPath: IndexPath?
    var ref: DatabaseReference!
    
    lazy var titleSize: (width: CGFloat, height: CGFloat) = {
        let insetPadding: CGFloat = 8
        let width = view.frame.width - 2 * insetPadding
        let heightRatio: CGFloat = 0.85246
        return (width, width * heightRatio)
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: CollectionCell.padding,
                                           left: CollectionCell.padding,
                                           bottom: CollectionCell.padding,
                                           right: CollectionCell.padding)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.identifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.register(FooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterView.reuseIdentifier)
        return collectionView
    }()
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)])

        //What is this mish mosh mess?
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo.svg")?.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = .black
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
        navigationItem.titleView?.alpha = 0
//        navigationItem.titleView?.backgroundColor = .white
//        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .lightGray
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
     
        
        //Firebase DB
        ref = Database.database().reference().child("Items")
        let query = ref.queryOrdered(byChild: "category").queryEqual(toValue: "GOGGLES")
        
        query.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                K.goggleData.removeAll()
                
                for itemSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    if let obj = itemSnapshot.value as? [String: AnyObject] {
                        let item = GoggleData(vendorNo: obj["vendorPartNo"] as! String,
                                              sku: obj["TRSku"] as! Int64,
                                              category: obj["category"] as! String,
                                              brand: obj["model"] as! String,
                                              description: obj["description"] as! String,
                                              unitPrice: obj["unitPrice"] as? Float ?? 0,
                                              qty: obj["TRQty"] as? Int ?? 0,
                                              qtyOrdered: obj["qtyOrdered"] as? Int,
                                              image: Storage.storage().reference().child((obj["vendorPartNo"] as! String) + ".png"))
                        K.goggleData.append(item)
                        
                        //Populate the unique goggleBrands
                        if !K.goggleBrands.contains(item.brand) {
                            K.goggleBrands.append(item.brand)
                        }
                        
                        self.collectionView.reloadData()
                    }
                }
            }
        } //end query.observe...
    } //end viewDidLoad
    
    
}


// MARK: - Logout

extension BuyGogglesController {
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
            print("Sign out successful")
            
            self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
        }
        catch let signoutError as NSError {
            print("Error signing out: %@", signoutError)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension BuyGogglesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard indexPath.section > 0 else {
            return CGSize(width: titleSize.width, height: titleSize.height)
        }

        return CGSize(width: CollectionCell.widthImageView, height: CollectionCell.heightStack)
    }
}


// MARK: - UICollectionViewDataSource

extension BuyGogglesController: UICollectionViewDataSource {
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return K.goggleBrands.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section > 0 else {
            return 1
        }
        
        let goggleForBrand = K.goggleData.filter { $0.brand == K.goggleBrands[section - 1] }

        return goggleForBrand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section > 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.identifier, for: indexPath) as! TitleCell
            
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
        
        cell.backgroundColor = .white
        
        
        
        
        //USE REALTIME DATABASE HERE...
        let goggleForBrand = K.goggleData.filter { $0.brand == K.goggleBrands[indexPath.section - 1] }

        cell.imageView.sd_setImage(with: Storage.storage().reference().child(goggleForBrand[indexPath.row].vendorNo + ".png"))
        cell.skuLabel.text = "\(goggleForBrand[indexPath.row].sku)" + " - " + goggleForBrand[indexPath.row].description + "\n" + ((goggleForBrand[indexPath.row].qtyOrdered != nil && goggleForBrand[indexPath.row].qtyOrdered! > 0) ? "Ordered: \(goggleForBrand[indexPath.row].qtyOrdered!)" : "")
        
        if (goggleForBrand[indexPath.row].qtyOrdered != nil && goggleForBrand[indexPath.row].qtyOrdered! > 0) {
            cell.layer.borderWidth = 3
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor(named: "colorHighlight")!.cgColor
            cell.clipsToBounds = true
        }
        else {
            cell.layer.borderWidth = 0
            cell.clipsToBounds = false
        }
        
        
        
        
        
        
        
        
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: HeaderView.reuseIdentifier,
                                                                         for: indexPath) as! HeaderView
            header.label.text = K.goggleBrands[indexPath.section - 1]
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
                let goggleForBrand = K.goggleData.filter { $0.brand == K.goggleBrands[indexPath.section - 1] }
                
//                controller.vendorNo = goggleForBrand[indexPath.row].vendorNo
//                controller.brand = goggleForBrand[indexPath.row].brand
//                controller.refImage = goggleForBrand[indexPath.row].image
//                controller.itemDescription = "\(goggleForBrand[indexPath.row].sku)" + " - " + goggleForBrand[indexPath.row].description
//                controller.qtyAvailable = goggleForBrand[indexPath.row].qty
//                controller.qtyOrdered = goggleForBrand[indexPath.row].qtyOrdered

                //Firebase DB
                controller.ref = ref.child(goggleForBrand[indexPath.row].vendorNo)
                controller.item = goggleForBrand[indexPath.row]
                
                //Not sure about theses.....
                controller.delegate = self
                orderIndexPath = indexPath
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section > 0 else {
            return
        }
        
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard section > 0 else {
            return .zero
        }
        
        return CGSize(width: view.frame.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard section > 0 else {
            return .zero
        }
        
        return CGSize(width: view.frame.size.width, height: 40)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationItem.titleView?.alpha = (scrollView.contentOffset.y - titleSize.height / 2) / (titleSize.height / 2)
//        if navigationItem.titleView!.alpha >= 1.0 {
//            appearance.shadowColor = .lightGray
//            navigationController?.navigationBar.standardAppearance = appearance
//        }
        
//        if scrollView.contentOffset.y > view.frame.width - 16 {
//            navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//        else {
//            navigationController?.setNavigationBarHidden(true, animated: true)
//        }
//        let newHeight = scrollHeightAnchor.constant - scrollView.contentOffset.y / 2
//        
//        guard newHeight > 0 && newHeight < scrollHeightMax else {
//            return
//        }
//
//        scrollHeightAnchor.constant = newHeight
//        print("offset: \(scrollView.contentOffset.y), origin: \(scrollView.bounds.origin.y), anchor: \(scrollHeightAnchor.constant)")
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
        
        tabBarController?.tabBar.items?.last?.badgeValue = K.shoppingCart.count > 0 ? "\(K.shoppingCart.count)" : nil
        
        collectionView.reloadData()
    }
    
}

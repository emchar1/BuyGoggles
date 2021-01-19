//
//  AppDelegate.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/12/20.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        //Creates Firebase firestore and checks that you can access it. That's it.
        let db = Firestore.firestore()
        print(db)
        
        //Get the google data from a csv file in the app. Need to change this to JSON maybe???
        getGoggleData(filename: "TRInventory11-2020", ext: "csv")
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}


extension AppDelegate {
    
    /**
     Parses the Inventory file to load in the goggleData global variable
     - parameters:
     - filename: name of the file without the extension
     - ext: Now the extension
     */
    func getGoggleData(filename: String, ext: String) {
        guard let path = Bundle.main.path(forResource: filename, ofType: ext) else {
            print("\(filename).\(ext) not found.")
            return
        }
        
        do {
            let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let lines = data.components(separatedBy: .newlines)
            
            //loop through all lines of code in the inventory file
            for (index, line) in lines.enumerated() {
                if index > 0, line.count > 0 {
                    let columns = line.components(separatedBy: ",")
                    
                    if columns[K.columnCategory] == "GOGGLES" {
                        if !K.goggleBrands.contains(columns[K.columnBrand]) {
                            K.goggleBrands.append(columns[K.columnBrand])
                        }
                        
                        let vendorNo = columns[K.columnVendorNo]
                        let sku = columns[K.columnSKU]
                        let brand = columns[K.columnBrand]
                        let itemDescription = columns[K.columnDescription]
                        let unitPrice = columns[K.columnUnitPrice]
                        let qty = columns[K.columnQty]
                        
                        //Only add GoggleData if there's an image associated with it. Or should we include all goggles???
                        if let image = UIImage(named: "\(vendorNo).png") {
                            K.goggleData.append(GoggleData(brand: brand,
                                                           vendorNo: vendorNo,
                                                           sku: sku,
                                                           description: itemDescription,
                                                           image: image,
                                                           unitPrice: Float(unitPrice) ?? -9999,
                                                           qty: Int(qty) ?? -9999))
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        
        //Sort the damn array... finally! Had to conform GoggleData to Comparable. Easy peasy!
        K.goggleData.sort { $0 < $1 }
        K.goggleBrands.sort { $0 < $1 }
    }
}

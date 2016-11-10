//
//  UIAlertController+CustomAlerts.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/10/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func alert(withRetryClosure retryClosure: @escaping () -> ()) -> UIAlertController {
        let alertController = UIAlertController(title: "Ops!", message: "Error fetching new products. Retry?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { alertAction in
            retryClosure()
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        return alertController
    }
    
}

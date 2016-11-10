//
//  ProductHeaderView.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/9/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class ProductHeaderView: UICollectionReusableView {
        
    @IBOutlet var orderingSegmentedControl: UISegmentedControl!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func orderingChanged(_ sender: UISegmentedControl) {
        
    }
    
}

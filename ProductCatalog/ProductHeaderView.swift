//
//  ProductHeaderView.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/9/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

protocol OrderingSegmentedControlDelegate {
    func orderingChangedTo(sortType: BestBuyAPI.ListProductsSort)
}

class ProductHeaderView: UICollectionReusableView {
        
    @IBOutlet var orderingSegmentedControl: UISegmentedControl!
    @IBOutlet var searchBar: UISearchBar!
    
    var delegate: OrderingSegmentedControlDelegate?
    
    @IBAction func orderingChanged(_ sender: UISegmentedControl) {
        delegate?.orderingChangedTo(sortType: sender.selectedSegmentIndex == 0 ? .DESC : .ASC)
    }
    
}

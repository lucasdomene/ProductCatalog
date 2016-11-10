//
//  ProductZoomViewController.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/10/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import UIKit

class ProductZoomViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - @IBOutlets
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var closeButton: UIButton!
    
    // MARK: - @Attributes
    
    var image: UIImage!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5
        
        view.bringSubview(toFront: closeButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = image
    }
    
    // MARK: - @IBActions
    
    /// Dismiss viewController
    @IBAction func closeView(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

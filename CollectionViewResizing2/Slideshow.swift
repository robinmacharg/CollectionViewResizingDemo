//
//  Slideshow.swift
//  CollectionViewResizing2
//
//  Created by Robin Macharg on 3/14/18.
//  Copyright © 2018 Robin Macharg. All rights reserved.
//

import UIKit

class Slideshow: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var previousPage: Int = 0
    var cellSize: CGSize = CGSize(width: 1024, height: 768)
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = NoFadeFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func scaleCell(view: UIView) {
        var transform = CGAffineTransform.identity
        let scale = self.view.width / 1024.0
        let scaledX = scale * 1024
        let xTranslate = -(((view.width) - scaledX) / 2)
        
        print("scale (slideshow): \(scale)")
        print("translate (slideshow): \(xTranslate)")
        
        transform = transform.translatedBy(
            x: xTranslate,
            y: 0)
        transform = transform.scaledBy(x: scale, y: scale)
        
        view.transform = transform
    }
    
}

// MARK: - <UICollectionViewDataSource>

extension Slideshow: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomSlideCell", for: indexPath) as! CustomSlideCell
        
        // Brute-force previous embedded views away.  Scant attention to correct VC containment practice.
        for subview in cell.customSlideContainer.subviews {
            subview.removeFromSuperview()
        }
        
        if let customController = UIStoryboard.viewController(
            "CustomViewController1",
            as: CustomViewController1.self) {
        
            cell.controller = customController
            
            customController.willMove(toParentViewController: self)
            print("Cell Size: \(cell.size)")
            print("customController?.view.size: \(customController.view.size)")
            
            // Hardwired 4:3 full-screen aspect ratio
            customController.view.size = CGSize(width: 1024, height: 768)
            
            cell.customSlideContainer.addSubview((customController.view)!)
            self.addChildViewController(customController)
            customController.didMove(toParentViewController: self)
            
            cell.label.text = "\(indexPath.item)"
            
            customController.label.text = "\(indexPath.item)"
            
            // The initial scale is applied here.  Poss. could make use of the top-level container transform code.
            self.scaleCell(view: customController.view)
        }
        
        return cell
    }
}

// MARK: - <UICollectionViewDelegate>

extension Slideshow: UICollectionViewDelegate {
    // Track page changes.  Used for labels in the custom view and (more importantly) the contentOffset while animating.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractionalPage))
        if previousPage != page {
            previousPage = page
        }
    }
}

// MARK: - <UICollectionViewDelegateFlowLayout>

extension Slideshow: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("Collection View cell width: \(collectionView.size.width), \(collectionView.size.height)")
        return cellSize
    }
}

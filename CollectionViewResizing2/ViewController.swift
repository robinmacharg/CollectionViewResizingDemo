//
//  ViewController.swift
//  CollectionViewResizing2
//
//  Created by Robin Macharg on 3/14/18.
//  Copyright © 2018 Robin Macharg. All rights reserved.

import UIKit

let MENULARGE: CGFloat = 300.0
let MENUSMALL: CGFloat = 100.0
let ANIMATIONDURATION = 0.3

class ViewController: UIViewController {
    @IBOutlet weak var menuConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideshowContainer: UIView!
    
    var menuIsSmall = false
    var menuWidth: CGFloat = MENULARGE
    
    var slideshowController: Slideshow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuConstraint.constant = menuWidth
        
        // Embed the Slideshow container
        slideshowController = UIStoryboard.viewController("Slideshow", as: Slideshow.self)
        slideshowController?.willMove(toParentViewController: self)
        slideshowController?.view.size = slideshowContainer.size
        slideshowContainer.addSubview((slideshowController?.view)!)
        self.addChildViewController(slideshowController!)
        slideshowController?.didMove(toParentViewController: self)
        
        // Hardwired initial size
        slideshowController?.cellSize = CGSize(width: 724, height: 768)
    }

    // MARK: - Actions
    
    @IBAction func toggleMenu(_ sender: Any) {
        menuWidth = self.menuIsSmall ? MENULARGE : MENUSMALL
        
        // these changes will be animated in the animation block, below
        menuConstraint.constant = menuWidth
        slideContainerConstraint.constant = menuWidth
        
        // We also tell the slideshow controller since it gets asked by the FlowLayout for new cells
        let newWidth = UIScreen.main.bounds.width - menuWidth
        print("New width: \(newWidth)")
        self.slideshowController?.cellSize = CGSize(width: newWidth, height: 768)
        
        // Inform the collection that the layout is not correct to ensure that it updates its state
        self.slideshowController?.collectionView.collectionViewLayout.invalidateLayout()
        
        // Then we animate quite a few things, all at once
        UIView.animate(withDuration: ANIMATIONDURATION, animations: {
            
            // Runs the collection view layout
            self.slideshowController?.collectionView.performBatchUpdates(nil, completion: nil)
            
            // Get the current cell and its view based on the page number (which we track manually)
            let indexPath = IndexPath(item: (self.slideshowController?.previousPage)!, section: 0)
            if let cell = self.slideshowController?.collectionView.cellForItem(at: indexPath) {
                let view = (cell as? CustomSlideCell)?.controller?.view
                print("View: \(view == nil ? "No View" : String(describing:view!))")

                // We base our new translate on some of the old transform
                let currentTransform = ((cell as? CustomSlideCell)?.controller?.view)!.transform
                print("Current Transform: \(currentTransform)")
                
                // The new scale is the width / the screen size, the hardwired assumption being that our slides will be full-screen-ratio
                let newScale = newWidth / 1024.0
                print("New Scale: \(newScale)")
                
                // Half the difference between the current scaled size and the new scaled size
                let halfDiff = ((newScale * 1024) - (view?.width)!) / 2.0
                
                // Determine the updated translation
                let newTranslate = currentTransform.tx + halfDiff
                
                // Start with an identity transform and modify it with the new scale and translation
                var transform = CGAffineTransform.identity
                transform = transform.translatedBy(x: newTranslate, y: 0.0)
                transform = transform.scaledBy(x: newScale, y: newScale)
                
                // Then apply it
                view?.transform = transform
            }
            
            // Works to ensure that +ve indexPaths are offset correctly at the end of the animation
            self.slideshowController?.collectionView.contentOffset = CGPoint(x: CGFloat((self.slideshowController?.previousPage)!) * newWidth, y: 0.0)
            print("Content Offset: \(CGPoint(x: CGFloat((self.slideshowController?.previousPage)!) * newWidth, y: 0.0))")

            // Finally this animates the constraints and any other layout changes
            self.view.layoutIfNeeded()
        }) { (completed) in
            self.menuIsSmall = !self.menuIsSmall
        }
    }
}


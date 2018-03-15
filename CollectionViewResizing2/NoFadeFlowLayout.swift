//
//  NoFadeFlowLayout.swift
//  CollectionViewResizing2
//
//  Created by Robin Macharg on 3/14/18.
//  Copyright © 2018 Robin Macharg. All rights reserved.
//

// This FlowLLayout sorts out the to-alpha flicker in the default one.
//
// Useful refs:
// https://www.raizlabs.com/dev/2014/02/animating-items-in-a-uicollectionview/
// Or: https://stackoverflow.com/a/48698115/2431627

import UIKit

// https://stackoverflow.com/a/48698115/2431627
class NoFadeFlowLayout: UICollectionViewFlowLayout {
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attrs?.alpha = 1.0
        return attrs
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attrs?.alpha = 1.0
        return attrs
    }
}

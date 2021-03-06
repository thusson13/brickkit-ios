//
//  MinimumStickyLayoutBehavior.swift
//  BrickKit
//
//  Created by Ruben Cagnie on 6/3/16.
//  Copyright © 2016 Wayfair LLC. All rights reserved.
//

public protocol MinimumStickyLayoutBehaviorDataSource: StickyLayoutBehaviorDataSource {
    func stickyLayoutBehavior(behavior: StickyLayoutBehavior, minimumStickingHeightForItemAtIndexPath indexPath: NSIndexPath, withIdentifier identifier: String, inCollectionViewLayout collectionViewLayout: UICollectionViewLayout) -> CGFloat?
}

/// Allows the brick to stick, but will shrink to a minimum height first
public class MinimumStickyLayoutBehavior: StickyLayoutBehavior {

    override func updateFrameForAttribute(inout attributes:BrickLayoutAttributes, sectionAttributes: BrickLayoutAttributes?, lastStickyFrame: CGRect, contentBounds: CGRect, collectionViewLayout: UICollectionViewLayout) -> Bool {
        super.updateFrameForAttribute(&attributes, sectionAttributes: sectionAttributes, lastStickyFrame: lastStickyFrame, contentBounds: contentBounds, collectionViewLayout: collectionViewLayout)

        guard let minimumDataSource = dataSource as? MinimumStickyLayoutBehaviorDataSource else {
            return true
        }

        if let minStickyHeight = minimumDataSource.stickyLayoutBehavior(self, minimumStickingHeightForItemAtIndexPath: attributes.indexPath, withIdentifier: attributes.identifier, inCollectionViewLayout: collectionViewLayout) {
            let heightLost = attributes.frame.origin.y - attributes.originalFrame.origin.y
            attributes.frame.size.height = max(attributes.originalFrame.height - heightLost, minStickyHeight)
        } else {
            attributes.frame.size.height = attributes.originalFrame.height
        }

        return true
    }

}

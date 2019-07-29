//
//  MainCollectionLayout.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 29/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit


//struct UltravisualLayoutConstants {
//    struct Cell {
//        // The height of the non-featured cell
//        static let standardHeight: CGFloat = 180
//        // The height of the first visible cell
//        static let featuredHeight: CGFloat = 200
//    }
//}

protocol CustomCollectionViewDelegate: class {
    func theNumberOfItemsInCollectionView() -> Int
}

extension CustomCollectionViewDelegate {
    func heightForContentInItem(inCollectionView collectionView: UICollectionView, at indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

class MainCollectionLayout: UICollectionViewLayout {
//    fileprivate var numberOfColumns = 1
    weak var delegate: CustomCollectionViewDelegate?
    let dragOffset: CGFloat = 275.0
    // Returns the item index of the currently featured cell
    var increaseItemIndex: Int = 0
    var decreaseItemIndex: Int = 0
    //An array to cache the calculated attributes
    private var cache = [UICollectionViewLayoutAttributes]()
    var nextItemPercentageOffset: CGFloat {
        return  (collectionView!.contentOffset.x / dragOffset)// - CGFloat(featuredItemIndex)
    }
    
    // Returns the width of the collection view
    
    var standardWidth:CGFloat {
        return width*0.7
    }
    var standardHeight: CGFloat {
        return height*0.7
    }
    var featureWidth:CGFloat {
        return width*0.8
    }
    var featureHeight: CGFloat {
        return height*0.8
    }
    // The height of the first visible cell
   // static let featuredHeight: CGFloat = 200
    
    // Returns the height of the collection view
    var width: CGFloat {
        return collectionView!.bounds.width
    }
    var height: CGFloat {
        return collectionView!.bounds.height
    }
    var numberOfItems: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    override var collectionViewContentSize : CGSize {
        let contentWidth = (CGFloat(numberOfItems) * dragOffset) + (width - dragOffset)
        return CGSize(width: contentWidth, height: height)
    }
    
    override func prepare() {
      //  We begin measuring the location of items only if the cache is empty
        guard cache.isEmpty == true, let collectionView = collectionView else {return}
        //cache.removeAll(keepingCapacity: false)
        let standardHeight = self.standardHeight
        let featuredHeight = self.featureHeight
        
        var frame = CGRect.zero
        var x: CGFloat = 0
        
        for item in 0..<numberOfItems {
            
            // Important because each cell has to slide over the top of the previous one
            //attributes.zIndex = item
            // Initially set the height of the cell to the standard height
            var height = standardHeight
            
            
           
            var newWidth:CGFloat = standardWidth
            var newHeight:CGFloat = standardHeight
            
            if x <= (width-featureWidth)/2{
//                newWidth = featureWidth - max((featureWidth - standardWidth) * nextItemPercentageOffset, 0)
//                let maxX = x + width
//                newHeight = featuredHeight - max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
//                x = maxX - width

            }else if(x<=width){
                
                newWidth = standardWidth + max((featureWidth - standardWidth) * nextItemPercentageOffset, 0)
                let maxX = x + width
                newHeight = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
                x = maxX - width
            }
            let indexPath = IndexPath(item: item, section: 0)

            if indexPath.item == 0 {
                x = (width - featureWidth)/2
                frame = CGRect(x: (width-featureWidth)/2, y: 0, width: featureWidth, height: featuredHeight)
            }else{
                frame = CGRect(x: x, y: 0, width: newWidth, height: newHeight)
            }
            

//            if indexPath.item == featuredItemIndex {
//                // The featured cell
//                let xOffset = standardHeight * nextItemPercentageOffset
//                x = collectionView!.contentOffset.x - xOffset
//                height = featuredHeight
//                if indexPath.item == 0 {
//                    x = (width - standardWidth)/2
//                }
//            } else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
//                // The cell directly below the featured cell, which grows as the user scrolls
//                let maxX = x + width
//                height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
//                x = maxX - width
//            }
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            x = frame.maxX
            
            
        }
        
        
    }
    
    //Is called  to determine which items are visible in the given rect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        //Loop through the cache and look for items in the rect
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }

        return visibleLayoutAttributes
    }
    //The attributes for the item at the indexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    

//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }

    
}




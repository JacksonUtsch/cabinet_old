////
////  PinLayout.swift
////  Kudos
////
////  Created by Jason Blood on 8/10/14.
////  Copyright (c) 2014 Jason Blood Inc. All rights reserved.
////
//
//import Cocoa
//
//protocol PinLayoutDelegate: NSCollectionViewDelegate
//{
//    func heightForItemAtIndexPath(indexPath: NSIndexPath) -> Double
//    func layoutSizeChanged(size: CGSize)
//}
//
//class PinLayout: NSCollectionViewLayout
//{
//    var columnCount: Int = 2
//    var delegate: PinLayoutDelegate? = nil
//    var itemCount: Int = 0
//    var itemAttributes = NSMutableArray()
//    var columnHeights = NSMutableArray()
//    
//    override func prepare()
//    {
//        super.prepare()
//        
//        itemCount = self.collectionView!.numberOfItems(inSection: 0)
//        let itemWidth = self.collectionView!.frame.size.width / CGFloat(columnCount)
//        itemAttributes = NSMutableArray.init(capacity: itemCount)
//        columnHeights = NSMutableArray.init(capacity:columnCount)
//        
//        //init the height at the very top
//        for i in 0...columnCount {
//            columnHeights[i] = 0;
//        }
//        
//        //item is always placed into shortest column
//        for i in 0...columnCount {
//            let indexPath: NSIndexPath = NSIndexPath(forItem: i, inSection: 0)
//            var itemHeight = delegate?.heightForItemAtIndexPath(indexPath: indexPath)
//            let columnIndex = self.shortestColumnIndex()
//            let xOffset = itemWidth * CGFloat(columnIndex)
//            var yOffset: CGFloat = 0
//            
//            if (itemHeight == nil)
//            {
//                itemHeight = 0
//            }
//            if (columnHeights.count > columnIndex)
//            {
//                yOffset = CGFloat(columnHeights[columnIndex] as! NSNumber)
//            }
//            
//            //println("position \(xOffset), \(yOffset), \(columnIndex), \(itemWidth)")
//            
//            let attributes : NSCollectionViewLayoutAttributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath as IndexPath)
//            attributes.frame = CGRect(x: xOffset, y: yOffset, width: CGFloat(itemWidth), height: CGFloat(itemHeight!))
//            itemAttributes.add(attributes)
//            if (columnHeights.count > columnIndex)
//            {
//                columnHeights[columnIndex] = yOffset + CGFloat(itemHeight!);
//                //println("column: \(columnIndex) = \(columnHeights[columnIndex])")
//            }
//        }
//    }
//    
//     override func collectionViewContentSize() -> NSSize
//    {
//        if (itemCount == 0)
//        {
//            return CGSize.zero;
//        }
//        
//        var contentSize = self.collectionView!.frame.size
//        let columnIndex = self.longestColumnIndex();
//        var height = CGFloat(0.0)
//        if (columnHeights.count > columnIndex)
//        {
//            height = CGFloat(columnHeights[columnIndex] as! NSNumber)
//        }
//        contentSize.height = height;
//        
//        self.delegate?.layoutSizeChanged(size: contentSize)
//        
//        return contentSize;
//    }
//    func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath!) -> NSCollectionViewLayoutAttributes!
//    {
//        return itemAttributes[indexPath.item] as! NSCollectionViewLayoutAttributes
//    }
//    func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]!
//    {
//        let predicate = NSPredicate { (a : CGRect!, b: [NSObject : AnyObject]!) -> Bool in
//            return CGRectIntersectsRect(rect, a as! CGRect)
//        }
//        return itemAttributes.filteredArrayUsingPredicate(predicate)
//    }
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool
//    {
//        return false;
//    }
//    
//    func shortestColumnIndex() -> Int
//    {
//        var i : Int = 0
//        var shortestHeight : Double = Double.infinity
//        
//        columnHeights.enumerateObjects({object, index, stop in
//            let height : Double = (object as AnyObject).doubleValue
//            if (height < shortestHeight)
//            {
//                shortestHeight = height
//                i = index
//            }
//        })
//        
//        return i
//    }
//    func longestColumnIndex() -> Int
//    {
//        var i : Int = 0
//        var longestHeight : Double = 0
//        
//        columnHeights.enumerateObjects({object, index, stop in
//            let height : Double = (object as AnyObject).doubleValue
//            if (height > longestHeight)
//            {
//                longestHeight = height
//                i = index
//            }
//        })
//        
//        return i
//    }
//}

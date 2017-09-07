//
//  Masonry.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/31/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

/*
 
 What is needed?
 • screen size
 • view size
 • image array
 
 What is returned?
 • size array

 This is how you would use this function:
 
    let sizeArray = Masonry(images:imageArray)
    for i in images.count {
        images[i] = sizeArray[i]
    }

 */

protocol PintererestLayoutDelegate {
    
    func collectionView(collectionView: NSCollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

class PinterestLayout : NSCollectionViewLayout {
    
    var delegate: PintererestLayoutDelegate!
    var numberOfColumns = 1
    
    override var collectionViewContentSize: NSSize {
        get {
            return NSSize(width: width, height: contentHeight)
        }
    }
    
    private var cache = [NSCollectionViewLayoutAttributes]()
    private var contentHeight:CGFloat = 0
    private var width:CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    override func prepare() {
        if cache.isEmpty {
            let columnWidth = width / CGFloat(numberOfColumns)
            
            var xOffsets = [CGFloat]()
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * columnWidth)
            }
            
            var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
            
            var column = 0
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let height = delegate.collectionView(collectionView: collectionView!, heightForItemAtIndexPath: indexPath as NSIndexPath)
                let frame = NSRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
                let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath as IndexPath)
                attributes.frame = frame
                contentHeight = max(contentHeight, NSMaxX(frame))
                yOffsets[column] = yOffsets[column] + height
                column = column >= (numberOfColumns - 1) ? 0 : column // dunno
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        var layoutAttributes = [NSCollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}

extension PintererestLayoutDelegate {
    func collectionView(collectionView: NSCollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}




//enum imageType:Int {
//    case lowRes = 600
//    case medRes = 1080
//    case highRes
//}
//
//func Masonry(images:[NSImage]) -> [NSSize] {
//    var sizeArray:[NSSize] = []
//    
//    let columns = 4
//    var columnWidth = screenSize.width / CGFloat(columns)
//    
//    for image in images {
//        let qual = imageQual(image: image)
//        
//    }
//    
//    return sizeArray
//}
//
//func imageQual(image:NSImage) -> imageType {
//    let imageMass = image.size.width * image.size.height
//        if imageMass > imageType.medRes.rawValue {
//            if imageMass > imageType.highRes.rawValue {
//                return .highRes
//            }
//            return .medRes
//        }
//    return .lowRes
//}

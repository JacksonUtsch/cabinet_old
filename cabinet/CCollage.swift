//
//  CCollage.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/30/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

/*
 
 CHECK STARRED GITHUB REPOS (javascript)
 
 get aspect ratio
 get resolution
 resize to appropriate size/resolution based on:
    dpi
    factors of normal sizes
 */

class CCollage : NSScrollView {
    
    var path:URL! {
        didSet {
            content = nil
            content = CCollageView(path:path)
            self.documentView = content
        }
    }
    
    var content:CCollageView!
    
    init(frame frameRect: NSRect, path:URL) {
        super.init(frame: frameRect)
        self.path = path
        
        content = CCollageView(path:path)
        self.documentView = content
        content.autoPinEdge(.left, to: .left, of: self)
        content.autoPinEdge(.right, to: .right, of: self)
        content.autoPinEdge(.top, to: .top, of: self)
        content.autoMatch(.width, to: .width, of: self)
//        content.autoMatch(.height, to: .height, of: self) // change
        content.autoSetDimension(.height, toSize: 10000)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CCollageView : NSView {
    
    var path:URL!
    
    private var columns:Int = 4 {
        didSet {
            Swift.print("column number should change.")
        }
    }
    
    init(path:URL) {
        super.init(frame: NSRect())
        self.path = path
        self.autoresizesSubviews = true
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor
        let dir = FMDirectory(folderURL: path)
        var imageArray:[NSImage] = []
        for item in dir.contentsOrderedBy(.Name, ascending: true) {
            do {
                let data = try Data(contentsOf: item.url)
                let image = NSImage(data: data)
                if image != nil {
                    imageArray += [image!] // sort by size? (WxH)
                }
            } catch {
                Swift.print(error)
            }
        }
        imageArray = imageArray.sorted { $0.size.width < $1.size.width }
        var ySum:CGFloat = 0
        for image in imageArray {
            let imageRect = NSRect(x: 0, y: ySum, width: image.size.width , height: image.size.width)
            let imageView = NSImageView(frame: imageRect)
            imageView.image = image
            addSubview(imageView)
            ySum += imageRect.height
//            Swift.print(ySum)
        }
//        self.frame = NSRect(x: 0, y: 0, width: 123, height: 123)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidEndLiveResize() {
        let screenPercent = frame.width / screenSize.width
        let columnsToUse = getColumnNumber(percentOfScreenUsing: screenPercent)
        if columns != columnsToUse {
            columns = columnsToUse
        }
    }
    
    func getColumnNumber(percentOfScreenUsing:CGFloat) -> Int {
        if percentOfScreenUsing < 0.75 {
            if percentOfScreenUsing < 0.5 {
                if percentOfScreenUsing < 0.5 {
                    return 1 }
                return 2 }
            return 3 }
        return 4 }
}

//
//  Viewer.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/5/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

fileprivate let defaultPath = documentsPath
fileprivate let ctabHeight = appLayout.ctab.height()
fileprivate let cpathHeight = appLayout.cpath.height()

class CViewer : NSView {
    
    var paths:[URL] = [URL(fileURLWithPath: defaultPath)] {
        didSet {
            tabViewer.paths = paths
        }
    }
    
    var path:URL! {
        didSet {
            paths[activeIndex] = path
            fileViewer.path = path
            pathViewer.path = path
        }
    }
    
    var activeIndex:Int = 0 {
        didSet {
            path = paths[activeIndex]
        }
    }
    
    var tabViewer:CTab!
    var fileViewer:CFiles!
    var pathViewer:CPath!
    
    init(frame:NSRect, path:URL) {
        super.init(frame: frame)
        self.path = path
        
        tabViewer = CTab(frame: NSRect(x: 0, y: 0, width: screenSize.width, height: ctabHeight), paths: [path])
        fileViewer = CFiles(path: path)
        pathViewer = CPath(frame: NSRect(origin: CGPoint.zero, size: CGSize(width: screenSize.width, height: cpathHeight)), path: path)
        
        self.addSubview(fileViewer)
        self.addSubview(pathViewer)
        self.addSubview(tabViewer)

        /* AUTO LAYOUT */
        tabViewer.autoMatch(.width, to: .width, of: self)
        tabViewer.autoSetDimension(.height, toSize: ctabHeight)
        tabViewer.autoPinEdge(.left, to: .left, of: self)
        tabViewer.autoPinEdge(.right, to: .right, of: self)
        tabViewer.autoPinEdge(.top, to: .top, of: self)

        fileViewer.autoMatch(.width, to: .width, of: self)
        fileViewer.autoMatch(.height, to: .height, of: self, withOffset: -(ctabHeight + cpathHeight))
        fileViewer.autoPinEdge(.left, to: .left, of: self)
        fileViewer.autoPinEdge(.right, to: .right, of: self)
        fileViewer.autoPinEdge(.top, to: .bottom, of: tabViewer)
        
        pathViewer.autoMatch(.width, to: .width, of: self)
        pathViewer.autoSetDimension(.height, toSize: cpathHeight)
        pathViewer.autoPinEdge(.left, to: .left, of: self)
        pathViewer.autoPinEdge(.right, to: .right, of: self)
        pathViewer.autoPinEdge(.bottom, to: .bottom, of: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

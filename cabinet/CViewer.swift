//
//  Viewer.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/5/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

class CViewer : NSView {
    
    var path:URL/*!*/ = URL(fileURLWithPath: documentPath) {
        didSet {
            
        }
    }
    
    var files:CFiles!
    var hierarchy:CPath!
    
    init(frame frameRect: NSRect, path:URL) {
        super.init(frame: frameRect)
        self.path = path
        self.wantsLayer = true
        self.layer?.backgroundColor = colors.gray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

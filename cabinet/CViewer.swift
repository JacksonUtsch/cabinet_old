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
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = colors.gray.cgColor
        
        path = URL(fileURLWithPath: documentPath)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

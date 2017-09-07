//
//  CTab.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/22/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

/*
 
 much to do...
 
 • ui style
 • closing button
 • disk proper title "/"
 
 */

fileprivate let breakingPoint = screenSize.width / 13

class CTab : NSScrollView {
    
    var paths:[URL] = [] {
        didSet {
            content.paths = paths
        }
    }
    
    private var content:CTabView!
    
    init(frame frameRect: NSRect, paths:[URL]) {
        super.init(frame: frameRect)
        self.hasHorizontalScroller = true
        self.hasVerticalScroller = false
        self.backgroundColor = colors.gray
        
        content = CTabView(frame: frameRect, paths: paths)
        self.documentView = content
        
        content.autoPinEdgesToSuperviewEdges()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class CTabView : NSView {
    
    var paths:[URL] = [] {
        didSet {
            update()
        }
    }
    
    override var frame: NSRect {
        didSet {
            update()
        }
    }
    
    private var addButton:CTabAddBtn!
    
    init(frame frameRect: NSRect, paths:[URL]) {
        super.init(frame: frameRect)
        self.paths = paths
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
        // cleans the view of subviews
        if addButton != nil {
            addButton.removeFromSuperview()
        }
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // adds the tab subviews to the view
        let itemWid = (frame.width - frame.height) / CGFloat(paths.count)
        for path in paths.enumerated() {
            let tab = CTabItem(frame: NSRect(x: CGFloat(path.offset) * itemWid, y: 0, width: itemWid, height: frame.height), path: path.element, index: path.offset)
            addSubview(tab)
        }
        addButton = CTabAddBtn(frame: NSRect(x: frame.width - frame.height, y: 0, width: frame.height, height: frame.height))
        addSubview(addButton)
    }
}

fileprivate class CTabItem : NSView { // create button to remove tab
    
    private var path:URL!
    private var index:Int!
    
    init(frame frameRect: NSRect, path:URL, index:Int) {
        super.init(frame: frameRect)
        self.path = path
        self.index = index
        
        let title = NSTextField(frame: frameRect)
        title.frame.origin = CGPoint.zero
        title.makeNormal()
        title.stringValue = path.lastPathComponent
        addSubview(title)
        
        let openClick = NSClickGestureRecognizer(target: self, action: #selector(self.open))
        openClick.numberOfClicksRequired = 1
        title.addGestureRecognizer(openClick)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func open() {
        VCRef.viewer.activeIndex = index
    }
}

fileprivate class CTabAddBtn : NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        makeNormal()
        stringValue = "+"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseUp(with event: NSEvent) {
        VCRef.viewer.paths += [URL(fileURLWithPath: documentsPath)]
        VCRef.viewer.activeIndex = VCRef.viewer.paths.count - 1
    }
}

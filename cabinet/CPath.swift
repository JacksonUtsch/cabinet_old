//
//  CPath.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/10/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

/*
 
 • hide scroll bar
 • assure efficiency
 • clean and comment
 • show external connections and use var for disk location
 
 */

class CPath : NSScrollView {
    
    var path:URL! {
        didSet {
            content.path = path
            countPanel.fileCount = FMDirectory(folderURL: path).contentsOrderedBy(.Name, ascending: true).count
        }
    }
    
    var content:CPathView!
    
    var countPanel:CPathCountView!

    init(frame frameRect: NSRect, path:URL) {
        super.init(frame: frameRect)
        self.path = path
        
        hasVerticalScroller = false
        hasHorizontalScroller = true
        horizontalScroller = nil // removes scrolling view
        backgroundColor = themeColors().secondary
        
        countPanel = CPathCountView(fileCount: FMDirectory(folderURL: path).contentsOrderedBy(.Name, ascending: true).count)
        addSubview(countPanel)
        countPanel.autoPinEdge(.right, to: .right, of: self)
        countPanel.autoPinEdge(.bottom, to: .bottom, of: self)
        countPanel.autoMatch(.height, to: .height, of: self)
        countPanel.autoSetDimension(.width, toSize: frame.width * 0.1)

        content = CPathView(frame: frameRect, countPanelWidth: frame.width * 0.1, path: path)
        self.documentView = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class CPathView : NSView {
        
        var path:URL! {
            didSet {
                update()
            }
        }
        
        private let rootName = "disk"
        private let rootPath = "/"
        
        private var countPanelWidth:CGFloat!

        // init frame is used to prevent the use of an extra constraint to direct the initial position, better performance
        init(frame frameRect:NSRect, countPanelWidth:CGFloat, path:URL) {
            super.init(frame: frameRect)
            self.path = path
            self.countPanelWidth = countPanelWidth
            
            update()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func update() {
            
            // cleans the view of subviews
            for case let subview as CPathItem in subviews {
                subview.removeFromSuperview()
            }
            
            /// sums space needed in the view, initial value is padding
            var widthSum:CGFloat = 10
            
            if path!.pathComponents.count > 0 {
                
                for var component in path.pathComponents {
                    
                    // allows for display of name for root path (part 1/2)
                    if component == rootPath {
                        component = rootName
                    }
                    
                    widthSum += (component as NSString).size(withAttributes: [NSFontAttributeName: appLayout.cpath.font()]).width + appLayout.cpath.height()
                }
                
                var contentWidth = widthSum
                
                // creates views in reverse due to directory structure
                
                var tempPath = path
                var index = tempPath!.pathComponents.count
                
                for var component in path!.pathComponents.reversed() {
                    
                    // allows for display of name for root path (part 2/2)
                    if component == rootPath {
                        component = rootName
                    }
                    
                    contentWidth -= (component as NSString).size(withAttributes: [NSFontAttributeName: appLayout.cpath.font()]).width + appLayout.cpath.height()
                    let item = CPathItem(frame: NSRect(x: contentWidth, y: 0, width: (component as NSString).size(withAttributes: [NSFontAttributeName: appLayout.cpath.font()]).width + appLayout.cpath.height(), height: frame.height), path: tempPath!)
                    addSubview(item)
                    
                    tempPath = tempPath!.deletingLastPathComponent()
                    
                    if contentWidth < 0 {
                        contentWidth = 0
                    }
                    
                    index -= 1
                }
            }
            
            // adjusts the frame size for scrolling
            setFrameSize(NSSize(width: widthSum + countPanelWidth, height: frame.height))
        }
        
        class CPathItem : NSView {
            
            var path:URL!
            
            private var index:Int!
            private var name:String!
            
            init(frame frameRect: NSRect, path:URL) {
                super.init(frame: frameRect)
                self.path = path
                self.name = path.lastPathComponent
                
                if name == "/" {
                    name = "disk"
                }
                
                let hierarchyCircle = NSView(frame: NSRect(x: 0, y: (frameRect.height - frameRect.height/2) / 2, width: frameRect.height/2, height: frameRect.height/2))
                hierarchyCircle.wantsLayer = true
                var hierColor = NSColor.white
                for _ in 1...min(path.pathComponents.count, 12) {
                    hierColor = hierColor.darkened(amount: 0.05)
                }
                hierarchyCircle.layer!.backgroundColor = hierColor.cgColor
                hierarchyCircle.layer!.cornerRadius = min(hierarchyCircle.frame.width/2, hierarchyCircle.frame.height/2)
                addSubview(hierarchyCircle)
                
                let title = NSTextField(frame: NSRect(x: frameRect.height/2, y: -2, width: frameRect.width, height: frameRect.height))
                title.isBezeled = false
                title.isEditable = false
                title.drawsBackground = false
                title.font = appLayout.cpath.font()
                title.cell!.usesSingleLineMode = true
                title.stringValue = name
                title.isSelectable = false
                title.isEditable = false
                title.backgroundColor = NSColor.clear
                title.textColor = hierColor
                
                addSubview(title)
                
                let openClick = NSClickGestureRecognizer(target: self, action: #selector(self.open))
                openClick.numberOfClicksRequired = 2
                title.addGestureRecognizer(openClick)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            func open() {
                VCRef.viewer.path = path
            }
        }
    }
    
    class CPathCountView : NSView {
        
        override var frame: NSRect {
            didSet {
                #imageLiteral(resourceName: "folder-white").size = NSSize(width: frame.height, height: frame.height / 1.3)
            }
        }
        
        var fileCount:Int! {
            didSet {
                fileLabel.stringValue = String(describing: fileCount!)
                if fileCount != 1 {
                    fileLabel.stringValue += " items"
                } else {
                    fileLabel.stringValue += " item"
                }
            }
        }
        
        private var fileLabel = NSTextField()
        private var itemIcon = NSImageView(image: #imageLiteral(resourceName: "folder-white"))
        
        init(fileCount:Int) {
            super.init(frame: NSRect.zero)
            self.fileCount = fileCount
            
            wantsLayer = true
            layer!.backgroundColor = colors.regantGrey.cgColor
            
            fileLabel.makeNormal()
            fileLabel.backgroundColor = NSColor.clear
            fileLabel.textColor = NSColor.white
            addSubview(fileLabel)
            fileLabel.autoPinEdge(.right, to: .right, of: self)
            fileLabel.autoPinEdge(.bottom, to: .bottom, of: self)
            fileLabel.autoMatch(.width, to: .width, of: self, withMultiplier: 2/3)
            fileLabel.autoMatch(.height, to: .height, of: self, withOffset: -2)
            fileLabel.stringValue = String(describing: fileCount)
            fileLabel.alignment = .left
            if fileCount != 1 {
                fileLabel.stringValue += " items"
            } else {
                fileLabel.stringValue += " item"
            }
            
            addSubview(itemIcon)
            itemIcon.autoPinEdge(.left, to: .left, of: self)
            itemIcon.autoPinEdge(.top, to: .top, of: self)
            itemIcon.autoMatch(.height, to: .height, of: self)
            itemIcon.autoMatch(.width, to: .width, of: self, withMultiplier: 1/3)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

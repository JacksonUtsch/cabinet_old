//
//  CViewer.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/10/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

fileprivate var heightOffset:CGFloat = 0

class CFiles : NSScrollView {

    var path:URL! {
        didSet {
            content.path = path
        }
    }
    
    var content:CFilesView!
    
    init(path:URL) {
        super.init(frame: NSRect.zero)
        self.path = path
        self.backgroundColor = themeColors().primary
        
        content = CFilesView(path: path)
        self.documentView = content
        
        content.autoMatch(.width, to: .width, of: self)
        content.autoMatch(.height, to: .height, of: self)
        content.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 0, bottom: 0, right: 0), excludingEdge: .bottom)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class CFilesView : NSView {
        
        var path:URL! {
            didSet {
                update()
            }
        }
        
        private var downLocation:NSPoint!
        private var dragBox:NSView!
        
        override var frame: NSRect {
            didSet {
                update()
            }
        }

        init(path:URL) {
            super.init(frame: NSRect.zero)
            self.path = path
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func mouseDown(with event: NSEvent) {
            downLocation = event.locationInWindow
            
            /* SINGLE SELECTION */
            if flags.command == false && flags.shift == false {
                for case let subview as CFolder in subviews {
                    if subview.isRenaming == true {
                        subview.rename()
                    }
                    subview.selected = false
                }
            } else {
                for case let subview as CFolder in subviews {
                    if subview.isRenaming == true {
                        subview.rename()
                    }
                }
            }
        }
        
        override func mouseDragged(with event: NSEvent) {
            
            // removes dragBox
            if dragBox != nil {
                dragBox.removeFromSuperview()
            }
            
            let frame:NSRect = dragFrame(eventLoc: event.locationInWindow)
            dragBox = NSView(frame: frame)
            dragBox.wantsLayer = true
            dragBox.layer!.backgroundColor = colors.blue.cgColor
            dragBox.alphaValue = 0.3
            self.addSubview(dragBox)
            
            // determines which folders should be selected
            for case let subview as CFolder in subviews {
                let imageRect = subview.imageRect()
                let parentImageRect = NSRect(x: subview.frame.origin.x + imageRect.origin.x, y: subview.frame.origin.y + imageRect.origin.y, width: imageRect.width, height: imageRect.height)
                
                let textRect = subview.textRect()
                let parentTextRect = NSRect(x: subview.frame.origin.x + textRect.origin.x, y: subview.frame.origin.y + textRect.origin.y, width: textRect.width, height: textRect.height)
                
                if dragBox.frame.intersects(parentImageRect) || dragBox.frame.intersects(parentTextRect) {
                    subview.selected = true
                } else {
                    subview.selected = false
                }
            }
        }
        
        override func mouseUp(with event: NSEvent) {
            if dragBox != nil {
                dragBox.removeFromSuperview()
                dragBox = nil
            }
        }
        
        func update() {
            
            // cleans the view of subviews
            for case let subview as CFolder in subviews {
                subview.removeFromSuperview()
            }
            
            self.setFrameSize(NSSize(width: frame.width, height: frame.height + heightOffset))
            self.setFrameOrigin(NSPoint(x: frame.origin.x, y: frame.origin.y + heightOffset))
            
            // call func with sender of directory that returns ordered items in array and other preferences
            
            for item in FMDirectory(folderURL: path).contentsOrderedBy(.Name, ascending: true).enumerated() { // files push folders over
                if item.element.isFolder == true {
                    
                    let xInRow = Int(floor((self.frame.width - appLayout.cfolder.spacingSize().width) / (appLayout.cfolder.viewSize().width)))
                    
                    let xOffset:CGFloat = CGFloat(item.offset % xInRow) * appLayout.cfolder.viewSize().width
                    let yOffset = floor(CGFloat(item.offset) / CGFloat(xInRow)) * appLayout.cfolder.viewSize().height
                    
                    var folderRect = NSRect(origin: CGPoint.zero, size: appLayout.cfolder.viewSize())
                    folderRect.origin.x = appLayout.cfolder.spacingSize().width + xOffset
                    folderRect.origin.y = frame.height - appLayout.cfolder.spacingSize().height - yOffset - appLayout.cfolder.imageSize().height
                    
                    let folder = CFolder(frame: folderRect, url: item.element.url)
                    self.addSubview(folder)

                    heightOffset = yOffset
                    
//                    /* •••••••••••• manual resize starts here ••••••••••••• */
//                    
//                    self.setFrameSize(NSSize(width: superview!.frame.width, height: heightOffset))
//                    Swift.print(frame)
//                    
//                    /* •••••••••••• manual resize ends here ••••••••••••• */

                } else {
                    
                    let xInRow = Int(floor((self.frame.width - appLayout.cfolder.spacingSize().width) / (appLayout.cfolder.viewSize().width)))
                    
                    let xOffset:CGFloat = CGFloat(item.offset % xInRow) * appLayout.cfolder.viewSize().width
                    let yOffset = floor(CGFloat(item.offset) / CGFloat(xInRow)) * appLayout.cfolder.viewSize().height
                    
                    var folderRect = NSRect(origin: CGPoint.zero, size: appLayout.cfolder.viewSize())
                    folderRect.origin.x = appLayout.cfolder.spacingSize().width + xOffset
                    folderRect.origin.y = frame.height - appLayout.cfolder.spacingSize().height - yOffset - appLayout.cfolder.imageSize().height
                    
                    let file = CFile(frame: folderRect, url: item.element.url)
                    self.addSubview(file)
                    
                    heightOffset = yOffset

                }
            }
            
            self.scroll(NSPoint(x: 0, y: frame.height))
        }
        
//        func dirOrder() -> [FMDirectory] { // use other that includes tags, etc..?
//            
//        }
        
        func dragFrame(eventLoc:NSPoint) -> NSRect {
            
            let size = CGSize(width: eventLoc.x - downLocation.x, height: eventLoc.y - downLocation.y)
            let absSize = CGSize(width: abs(size.width), height: abs(size.height))
            
            var relativeLoc = downLocation!
            
            relativeLoc.y += (superview!.superview as! NSScrollView).documentVisibleRect.origin.y // accounts for the scroll position
            relativeLoc.y -= (superview!.superview as! NSScrollView).frame.origin.y // accounts for scroll view position in parent
            
            // x quadrant adjust
            if size.width < 0 {
                relativeLoc.x -= absSize.width
            }
            // y quadrant adjust
            if size.height < 0 {
                relativeLoc.y -= absSize.height
            }
            
            return NSRect(origin: relativeLoc, size: absSize)
        }
        
        func deselectFiles() {
            for case let subview as CFolder in subviews {
                subview.selected = false
            }
        }
        
        func numberSelected() -> Int {
            var count = 0
            for case let folder as CFolder in subviews {
                if folder.selected == true {
                    count += 1
                }
            }
            return count
        }
    }
}

//
//  CFile.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/10/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

class CFile : NSImageView {
    
    fileprivate var path:URL! { // extension issues
        willSet { // prepares for rename
            lastPath = path
            if dev == true { Swift.print("PREVIOUS PATH: " + path.absoluteString) }
        }
        didSet { // renames the folder
            if dev == true { Swift.print("NEW PATH: " + path.absoluteString) }
            do { try FileManager.default.moveItem(at: lastPath, to: path) } catch { Swift.print(error) }
        }
    }
    
    var selected : Bool = false {
        didSet {
            highlight.isHidden = selected.toggled()
        }
    }
    
    private var lastPath:URL!
    private var mouseDownHasSelf = false
    private var downPoint:NSPoint!
    private var draggedFile:CFile!
    private var draggedLabel:NSTextField!
    
    fileprivate var highlight:NSView!
    fileprivate var label:NSTextField!
    
    var isRenaming:Bool = false
    
    init(frame frameRect: NSRect, url:URL) {
        self.path = url
        super.init(frame: frameRect)
        
        layout(rect: frameRect)
        
        gestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(rect:NSRect) {
        #imageLiteral(resourceName: "file").size = NSSize(width: appLayout.cfolder.imageSize().height / 1.12608696, height: appLayout.cfolder.imageSize().height)
        self.image = #imageLiteral(resourceName: "file")
        
        let textSize = appLayout.cfolder.textSize()
        let fontAttributes = [NSFontAttributeName: appLayout.cfolder.font()]
        let wid = min((path.lastPathComponent as NSString).size(withAttributes: fontAttributes).width, rect.width)
        
        highlight = NSView(frame: NSRect(x: (rect.width - wid)/2, y: (appLayout.cfolder.font().capHeight * 2 - (textSize.height - textSize.height / 4)), width: wid, height: textSize.height - textSize.height / 4))
        highlight.wantsLayer = true
        highlight.layer!.backgroundColor = colors.blue.lighter().cgColor
        highlight.layer!.cornerRadius = 4
        highlight.alphaValue = 0.4
        highlight.isHidden = true
        self.addSubview(highlight)
        
        label = NSTextField(frame: NSRect(origin: NSPoint(x: 0, y: 0), size: textSize))
        label.stringValue = path.lastPathComponent
        label.alignment = .center
        label.font = appLayout.cfolder.font()
        label.textColor = colors.fiord
        label.cell!.usesSingleLineMode = true
        label.isBezeled = false
        label.isEditable = false
        label.drawsBackground = false
        self.addSubview(label) // change carot/cursor
    }
    
    private func gestures() {
        let touch = NSClickGestureRecognizer(target: self, action: #selector(self.touch(sender:)))
        touch.numberOfTouchesRequired = 1
        self.addGestureRecognizer(touch)
        
        let selectClick = NSClickGestureRecognizer(target: self, action: #selector(self.touch(sender:)))
        selectClick.numberOfClicksRequired = 1
        self.addGestureRecognizer(selectClick)
        
        let doubleClick = NSClickGestureRecognizer(target: self, action: #selector(self.open))
        doubleClick.numberOfClicksRequired = 2
        self.addGestureRecognizer(doubleClick)
        
        let doubleText = NSClickGestureRecognizer(target: self, action: #selector(self.renaming(sender:)))
        doubleText.numberOfClicksRequired = 2
        label.addGestureRecognizer(doubleText)
    }
    
    func touch(sender:NSClickGestureRecognizer) {
        if imageRect().contains(sender.location(in: self)) || highlight.frame.contains(sender.location(in: self)) { // click contains folder
            if flags.shift == false && flags.command == false {
                for case let subview as CFolder in (superview?.subviews)! { // deselects views
                    subview.selected = false
                }
                selected = true
            } else {
                selected.toggle()
            }
        } else {
            if flags.shift == false && flags.command == false {
                (superview as! CFiles.CFilesView).deselectFiles()
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        
        var imageFrame = frame
        imageFrame.size = imageRect().size
        imageFrame.origin.x += (frame.width - imageRect().width)/2
        imageFrame.origin.y += (frame.height - imageRect().height)/2 + imageRect().height/2
        
        var textFrame = frame
        textFrame.size = textRect().size
        textFrame.origin.x += (frame.width - textRect().width)/2
        textFrame.origin.y += (frame.height - textRect().height)/2 - textRect().height
        
        if convert(imageFrame, to: VCRef.view).contains(convert(event.locationInWindow, to: VCRef.view)) || convert(textFrame, to: VCRef.view).contains(convert(event.locationInWindow, to: VCRef.view)){
            mouseDownHasSelf = true
            downPoint = event.locationInWindow
            draggedFile = CFile(frame: self.frame, url: self.path)
            draggedFile.alphaValue = 0.8
            draggedFile.highlight.removeFromSuperview()
            superview!.addSubview(draggedFile)
            
            draggedLabel = NSTextField(frame: NSRect(x: 0, y: 0, width: imageRect().size.width/4, height: imageRect().size.width/4))
            draggedLabel.makeNormal()
            draggedLabel.wantsLayer = true
            draggedLabel.backgroundColor = colors.red
            draggedLabel.layer!.cornerRadius = draggedLabel.frame.width/2
            superview!.addSubview(draggedLabel)
        }
    }
    
    override func mouseDragged(with event: NSEvent) { // check selected, drag multiple files
        if mouseDownHasSelf == true {
            draggedFile.frame.origin = NSPoint(x: event.locationInWindow.x - downPoint.x + frame.origin.x, y: event.locationInWindow.y - downPoint.y + frame.origin.y)
            
            draggedLabel.stringValue = String(describing: (superview as! CFiles.CFilesView).numberSelected())
            draggedLabel.frame.origin = draggedFile.frame.origin
            draggedLabel.frame.origin.x += (draggedFile.frame.width - draggedFile.imageRect().width)/2 - draggedLabel.frame.width/2
            draggedLabel.frame.origin.y += (draggedFile.frame.height - draggedFile.imageRect().height)/2 + draggedFile.imageRect().height - draggedLabel.frame.height/2
            
            if selected == false {
                (superview as! CFiles.CFilesView).deselectFiles()
                selected = true
            }
            if (superview as! CFiles.CFilesView).numberSelected() != 1 {
                draggedFile.label.removeFromSuperview()
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if mouseDownHasSelf == true {
            if draggedFile != nil {
                draggedFile.removeFromSuperview()
                draggedFile = nil
            }
            if draggedLabel != nil {
                draggedLabel.removeFromSuperview()
                draggedLabel = nil
            }
            mouseDownHasSelf = false
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        
        var imageFrame = frame
        imageFrame.size = imageRect().size
        imageFrame.origin.x += (frame.width - imageRect().width)/2
        imageFrame.origin.y += (frame.height - imageRect().height)/2 + imageRect().height/2
        
        var textFrame = frame
        textFrame.size = textRect().size
        textFrame.origin.x += (frame.width - textRect().width)/2
        textFrame.origin.y += (frame.height - textRect().height)/2 - textRect().height
        
        if convert(imageFrame, to: VCRef.view).contains(convert(event.locationInWindow, to: VCRef.view)) || convert(textFrame, to: VCRef.view).contains(convert(event.locationInWindow, to: VCRef.view)){
            Swift.print("right click")
        }
    }
}

extension CFile {
    func imageRect() -> NSRect {
        return NSRect(origin: CGPoint(x: (frame.width - image!.size.width) / 2, y: (frame.height - image!.size.height) / 2), size: image!.size)
    }
    
    func textRect() -> NSRect {
        return NSRect(x: (frame.width - highlight.frame.width) / 2, y: highlight.frame.origin.y, width: highlight.frame.width, height: highlight.frame.height)
    }
    
    func open() {
        NSWorkspace.shared().open(VCRef.viewer.path)
    }
    
    func renaming(sender:NSClickGestureRecognizer) {
        label.isEditable = true
        label.currentEditor()?.selectWord(label.stringValue)
        label.window?.makeFirstResponder(label)
        selected = false
        isRenaming = true
    }
    
    func rename() {
        label.isSelectable = false
        label.window!.makeFirstResponder(nil)
        
        // takes care of spacing in name and sets new path
        let component = label.stringValue.replacingOccurrences(of: " ", with: "%20")
        let newP = path.deletingLastPathComponent().absoluteString + component + "/"
        if path.absoluteString != newP {
            path = URL(string: newP)
        }
        
        let textSize = appLayout.cfolder.textSize()
        let fontAttributes = [NSFontAttributeName: appLayout.cfolder.font()]
        let wid = min((label.stringValue as NSString).size(withAttributes: fontAttributes).width, frame.width)
        
        // resets highlight for adjusted size
        highlight.removeFromSuperview()
        highlight = NSView(frame: NSRect(x: (frame.width - wid)/2, y: (appLayout.cfolder.font().capHeight * 2 - (textSize.height - textSize.height / 4)), width: wid, height: textSize.height - textSize.height / 4))
        highlight.wantsLayer = true
        highlight.layer!.backgroundColor = colors.blue.lighter().cgColor
        highlight.layer!.cornerRadius = 4
        highlight.layer!.zPosition = -1
        highlight.alphaValue = 0.4
        highlight.isHidden = true
        addSubview(highlight)
        
        // assures text in is front
        label.removeFromSuperview()
        addSubview(label)
        
        isRenaming = false
    }
}

/*
 
 FILE TYPES:
 
 •psd
 •doc/docx
 •txt
 •swift
 •svg
 •png/jpeg
 
 */

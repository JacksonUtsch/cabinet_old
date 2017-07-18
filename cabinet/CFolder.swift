//
//  CFolder.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/10/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

/*  
 
    TODO:
    
    • modular sizing and placement
    • right click options
    • drag and drop items
    • renaming items
    • item padding

 */


class CFolder : NSImageView {
    
    private var path:URL! {
        willSet {
            previousLocation = path
            if dev == true { Swift.print("PREVIOUS PATH: " + path.absoluteString) }
        }
        
        didSet {
            if dev == true { Swift.print("NEW PATH: " + path.absoluteString) }
            do { try FileManager.default.moveItem(at: previousLocation!, to: path) } catch { Swift.print(error) }
        }
    }
    
    private var previousLocation:URL?
    
    var selected:Bool = false {
        didSet {
            if selected == false {
                folderHighlight.isHidden = true
            } else {
                folderHighlight.isHidden = false
            }
        }
    }
    
    private var downLocation = NSPoint(x: 0, y: 0)

    var folderHighlight:NSView!
    var folderText:NSTextField!
    var isRenaming:Bool = false
    
    private var dummyFolder:CFolder!

    init(frame frameRect: NSRect, url:URL) {
        self.path = url
        super.init(frame: frameRect)
        
        self.acceptsTouchEvents = true
        
        #imageLiteral(resourceName: "folder-light").size = appLayout.folders.imageSize()
        self.image = #imageLiteral(resourceName: "folder-light")
        
        let textSize = appLayout.folders.textSize()
        let fontAttributes = [NSFontAttributeName: appLayout.folders.font()]
        let wid = min((path.lastPathComponent as NSString).size(withAttributes: fontAttributes).width, frameRect.width)
        
        folderHighlight = NSView(frame: NSRect(x: (frameRect.width - wid)/2, y: (appLayout.folders.font().capHeight * 2 - (textSize.height - textSize.height / 4)), width: wid, height: textSize.height - textSize.height / 4))
        folderHighlight.wantsLayer = true
        folderHighlight.layer!.backgroundColor = colors.blue.lighter().cgColor
        folderHighlight.layer!.cornerRadius = Design.fileViewer.folder.selectCornerRadius
        folderHighlight.alphaValue = Design.fileViewer.folder.selectAlpha
        folderHighlight.isHidden = true
        self.addSubview(folderHighlight)

        folderText = NSTextField(frame: NSRect(origin: NSPoint(x: 0, y: 0), size: textSize))
        folderText.stringValue = path.lastPathComponent
        folderText.alignment = .center
        folderText.font = appLayout.folders.font()
        folderText.textColor = colors.fiord
        folderText.cell!.usesSingleLineMode = true
        folderText.isBezeled = false
        folderText.isEditable = false
        folderText.drawsBackground = false
        self.addSubview(folderText) // change carot/cursor
        
        let renameClick = NSClickGestureRecognizer(target: self, action: #selector(self.renaming(sender:)))
        renameClick.numberOfClicksRequired = 2
        folderText.addGestureRecognizer(renameClick)
        
        let openClick = NSClickGestureRecognizer(target: self, action: #selector(self.open))
        openClick.numberOfClicksRequired = 2
        self.addGestureRecognizer(openClick)
        
        let selectClick = NSClickGestureRecognizer(target: self, action: #selector(self.selectFolder(sender:)))
        selectClick.numberOfClicksRequired = 1
        self.addGestureRecognizer(selectClick)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renaming(sender:NSClickGestureRecognizer) {
        folderText.isEditable = true
        folderText.currentEditor()?.selectWord(folderText.stringValue)
        folderText.window?.makeFirstResponder(folderText)
        selected = false
        isRenaming = true
    }
    
    func rename() {
        // renames folder
        let component = folderText.stringValue.replacingOccurrences(of: " ", with: "%20")
        let newP = path.deletingLastPathComponent().absoluteString + component + "/"
        if path.absoluteString != newP {
            path = URL(string: newP)
        }

        let textSize = appLayout.folders.textSize()
        let fontAttributes = [NSFontAttributeName: appLayout.folders.font()]
        let wid = min((folderText.stringValue as NSString).size(withAttributes: fontAttributes).width, frame.width)

        folderHighlight.removeFromSuperview()
        folderHighlight = NSView(frame: NSRect(x: (frame.width - wid)/2, y: (appLayout.folders.font().capHeight * 2 - (textSize.height - textSize.height / 4)), width: wid, height: textSize.height - textSize.height / 4))
        folderHighlight.wantsLayer = true
        folderHighlight.layer!.backgroundColor = colors.blue.lighter().cgColor
        folderHighlight.layer!.cornerRadius = Design.fileViewer.folder.selectCornerRadius
        folderHighlight.layer!.zPosition = -1
        folderHighlight.alphaValue = Design.fileViewer.folder.selectAlpha
        folderHighlight.isHidden = true
        addSubview(folderHighlight)
        
        // assures text in is front
        folderText.removeFromSuperview()
        addSubview(folderText)
        
        isRenaming = false        
    }
    
    override func mouseDown(with event: NSEvent) {
        downLocation = event.locationInWindow
        dummyFolder = CFolder(frame: self.frame, url: self.path)
    }
    
    override func mouseDragged(with event: NSEvent) { // check selected, drag multiple files
        self.superview?.addSubview(dummyFolder)
        dummyFolder.frame.origin = NSPoint(x: event.locationInWindow.x - downLocation.x + frame.origin.x, y: downLocation.y - event.locationInWindow.y + 100)
        dummyFolder.alphaValue = 0.5
    }
    
    override func mouseUp(with event: NSEvent) {
        if dummyFolder != nil {
            dummyFolder.removeFromSuperview()
            dummyFolder = nil
        }
    }
    
    func selectFolder(sender:NSClickGestureRecognizer) {
        if imageRect().contains(sender.location(in: self)) || folderHighlight.frame.contains(sender.location(in: self)) {
            if flags.shift == false && flags.command == false {
                for case let subview as CFolder in (superview?.subviews)! { // deselects views
                    subview.selected = false
                }
            }
            selected = true
        } else {
            selected = false
        }
    }
    
    func open() {
        (self.superview as! CFiles).path = path
    }
    
    func imageRect() -> NSRect {
        return NSRect(origin: CGPoint(x: (frame.width - image!.size.width) / 2, y: (frame.height - image!.size.height) / 2), size: image!.size)
    }
    func textRect() -> NSRect {
        return NSRect(x: (frame.width - folderHighlight.frame.width) / 2, y: frame.height - (folderHighlight.frame.origin.y + folderHighlight.frame.height), width: folderHighlight.frame.width, height: folderHighlight.frame.height)
    }
}

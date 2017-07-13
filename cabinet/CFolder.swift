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


class CFolder : NSButton {
    
    var path:URL! {
        willSet {
            previousLocation = path
            Swift.print("PREVIOUS PATH: " + path.absoluteString)
        }
        
        didSet {
            Swift.print("NEW PATH: " + path.absoluteString)
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
    
    private var folderHighlight:NSView!

    var folderText:NSText!

    init(frame frameRect: NSRect, url:URL) {
        self.path = url
        super.init(frame: frameRect)
        
        self.acceptsTouchEvents = true
        self.isBordered = false
        self.setButtonType(.momentaryChange)
        
        #imageLiteral(resourceName: "folder-light").size = appLayout.folders.imageSize()
        self.image = #imageLiteral(resourceName: "folder-light")
        
        let textSize = appLayout.folders.textSize()
        
        
        let fontAttributes = [NSFontAttributeName: appLayout.folders.font()]
        let wid = min((path.lastPathComponent as NSString).size(withAttributes: fontAttributes).width, frameRect.width)
        
        folderHighlight = NSView(frame: NSRect(x: (frameRect.width - wid)/2, y: frameRect.height - (appLayout.folders.font().capHeight * 2), width: wid, height: textSize.height - textSize.height / 4))
        folderHighlight.wantsLayer = true
        folderHighlight.layer?.backgroundColor = colors.blue.lighter().cgColor
        folderHighlight.alphaValue = Design.fileViewer.folder.selectAlpha
        folderHighlight.isHidden = true
        folderHighlight.layer?.cornerRadius = Design.fileViewer.folder.selectCornerRadius
        
        self.addSubview(folderHighlight)

        folderText = NSText(frame: NSRect(origin: NSPoint(x: 0, y: frameRect.height - appLayout.folders.font().capHeight * 2), size: textSize))
        folderText.string = path.lastPathComponent
        folderText.isSelectable = false
        folderText.backgroundColor = NSColor.clear
        folderText.textColor = NSColor.white
        folderText.alignment = .center
        folderText.font = appLayout.folders.font()
        folderText.textColor = colors.fiord
        // change carot / cursor
        self.addSubview(folderText)
        
        
        let renameClick = NSClickGestureRecognizer(target: self, action: #selector(self.renaming(sender:)))
        renameClick.numberOfClicksRequired = 2
        folderText.addGestureRecognizer(renameClick)
        
        let openClick = NSClickGestureRecognizer(target: self, action: #selector(self.open))
        openClick.numberOfClicksRequired = 2
        self.addGestureRecognizer(openClick)
        
        let selectClick = NSClickGestureRecognizer(target: self, action: #selector(self.selectFolder))
        selectClick.numberOfClicksRequired = 1
        self.addGestureRecognizer(selectClick)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renaming(sender:NSClickGestureRecognizer) {
        if let txt = sender.view as? NSText {
            txt.isEditable = true
            txt.selectWord(txt.string)
            txt.window?.makeFirstResponder(txt)
            
//            var newP = path.absoluteString
//            let range:ClosedRange = (newP.characters.count - path.lastPathComponent.c)...(newP.characters.count)
//            newP.removeSubrange(Range(uncheckedBounds: (3,5)))
//            for _ in 1...path.lastPathComponent.characters.count {
//                newP.remove(at: newP.characters.count - 1) // same char error ??????!??!?!
//            }
            
//            let newP = path.deletingLastPathComponent().absoluteString + "/grid" + "/solitaire"
//            path = URL(string: "file:///Users/jutechs/Documents/projects/software/grid/solitaire/")
//            Swift.print(path.absoluteString)
        }
    }
    
    func rename() {
        
    }
    
    func selectFolder() {
        if flags.shift == false && flags.command == false {
            for case let subview as CFolder in (superview?.subviews)! { // deselects views
                subview.selected = false
            }
        }
        selected = true
    }
    
    func open() {
        (self.superview as! CFiles).path = path
    }
}

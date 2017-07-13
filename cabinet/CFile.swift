//
//  CFile.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/10/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

/*
 
    FILE TYPES:
 
    •psd
    •doc/docx
    •txt
    •swift
    •svg
    •png/jpeg
 
 */

class CFile : NSButton {
    
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
                textHighlight.isHidden = true
            } else {
                textHighlight.isHidden = false
            }
        }
    }
    
    private var textHighlight:NSView!
    private var text:NSText!

    init(frame frameRect: NSRect, url:URL) {
        self.path = url
        super.init(frame: frameRect)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectFile() {
        if flags.shift == false && flags.command == false {
            for case let subview as CFile in (superview?.subviews)! { // deselects views
                subview.selected = false
            }
        }
        selected = true
    }
    
    func open() {
        (self.superview as! CFiles).path = path
    }

}

//
//  Layout.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/12/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

/*
 
 CFolder:
 • Folder size (scale on screen size, user decides), apply for files and folders?
 • Folder spacing (assigned)
 • Text (based on folder size)
 • Text Highlight (based on text size)
 
 */

let defaults = UserDefaults.standard

struct defaultsKeys {
    struct general {
        static let fontName = "FontName"
    }
    struct folder {
        static let imageSize = "FolderImageSize"
    }
}

public class layout {
    
    var folders = folder()
    
    struct general {
        static var fontName:String! {
            didSet {
                defaults.set(fontName, forKey: defaultsKeys.general.fontName)
            }
        }
    }
    
    struct folder {
        static var imageNSSize:NSSize! {
            didSet {
                defaults.set(NSStringFromSize(imageNSSize), forKey: defaultsKeys.folder.imageSize)
            }
        }
        func imageSize() -> NSSize {
            return folder.imageNSSize
        }
        func spacingSize() -> NSSize {
            return NSSize(width: folder.imageNSSize.width * 0.6, height: folder.imageNSSize.width)
        }
        func viewSize() -> NSSize {
            return NSSize(width: folder.imageNSSize.width + spacingSize().width, height: folder.imageNSSize.height + spacingSize().height)
        }
        func font() -> NSFont {
            return NSFont(name: general.fontName, size: viewSize().width / 7)!
        }
        func textSize() -> NSSize {
            return NSSize(width: viewSize().width, height: font().capHeight * 2)
        }
    }
    
    init() {
        evalGeneral()
        evalFolder()
    }
    
    private func evalGeneral() {
        
        let fontName = defaults.string(forKey: defaultsKeys.general.fontName)
        if fontName != nil {
            general.fontName = fontName
        } else {
            general.fontName = "Avenir"
        }
    }
    
    private func evalFolder() {
        
        let imageString = defaults.string(forKey: defaultsKeys.folder.imageSize)
        if imageString != nil {
            let imageSize = NSSizeFromString(imageString!)
            if imageSize == NSSize(width: 0, height: 0) {
                Swift.print("folderImage in userDefaults may contain improper data.")
            }
            folder.imageNSSize = imageSize // ambiguos didSet use
        } else {
            folder.imageNSSize = NSSize(width: screenSize.width / 20, height: (screenSize.width / 20) * 0.72)
        }        
    }
}

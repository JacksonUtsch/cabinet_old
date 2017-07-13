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
        static let spacing = "FolderSpacing"
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
        static var spacingNSSize:NSSize! {
            didSet {
                defaults.set(NSStringFromSize(spacingNSSize), forKey: defaultsKeys.folder.spacing)
            }
        }
        func imageSize() -> NSSize {
            return folder.imageNSSize
        }
        func spacingSize() -> NSSize {
            return folder.spacingNSSize
        }
        func folderSize() -> NSSize {
            return NSSize(width: folder.imageNSSize.width + folder.spacingNSSize.width, height: folder.imageNSSize.height + folder.spacingNSSize.height)
        }
        func font() -> NSFont {
            return NSFont(name: general.fontName, size: self.folderSize().width / 7)!
        }
        func textSize() -> NSSize {
            return NSSize(width: self.folderSize().width, height: font().capHeight * 2)
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
        
        let spacingString = defaults.string(forKey: defaultsKeys.folder.spacing)
        if spacingString != nil {
            let spacingSize = NSSizeFromString(spacingString!)
            if spacingSize == NSSize(width: 0, height: 0) {
                Swift.print("folderSpacing in userDefaults may contain improper data.")
            }
            folder.spacingNSSize = spacingSize // ambiguos didSet use
        } else {
            folder.spacingNSSize = NSSize(width: folder.imageNSSize.width * 0.6, height: folder.imageNSSize.width)
        }
    }
}

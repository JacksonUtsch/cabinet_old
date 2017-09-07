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
    struct application {
        static let font = "appFont"
    }
    struct general {
        static let fontName = "FontName"
        static let defaultPath = "defaultPath"
    }
    struct cfolder {
        static let size = "cfolderSize"
        static let imageSize = "FolderImageSize"
    }
}

public struct des {
    
    struct application {
        static var font:String! {
            didSet {
                defaults.set(font, forKey: defaultsKeys.application.font)
            }
        }
    }
    
    struct cfolder {
        static var size:NSSize! {
            didSet {
                defaults.set(size, forKey: defaultsKeys.cfolder.size)
            }
        }
    }
    
    init() {
        // retrieve values, if none present, set defaults
    }
}

public class layout {
    
    var general = generals()
    var cpath = cpaths()
    var cfolder = cfolders()
    var ctab = ctabs()
    
    struct generals {
        static var fontName:String! {
            didSet {
                defaults.set(fontName, forKey: defaultsKeys.general.fontName)
            }
        }
//        static var defaultURL:URL! {
//            didSet {
//                defaults.set(defaultURL.absoluteString, forKey: defaultsKeys.general.defaultPath)
//            }
//        }
        func font() -> String {
            return generals.fontName
        }
//        func defaultPath() -> URL {
//            return generals.defaultURL
//        }
    }
    
    struct cpaths {
        func height() -> CGFloat {
            return screenSize.width * 0.02
        }
        func font() -> NSFont {
            return NSFont(name: "Avenir Next", size: 10)!
        }
    }
    
    struct cfolders {
        static var imageNSSize:NSSize! {
            didSet {
                defaults.set(NSStringFromSize(imageNSSize), forKey: defaultsKeys.cfolder.imageSize)
            }
        }
        func imageSize() -> NSSize {
            return cfolders.imageNSSize
        }
        func spacingSize() -> NSSize {
            return NSSize(width: cfolders.imageNSSize.width * 0.6, height: cfolders.imageNSSize.width)
        }
        func viewSize() -> NSSize {
            return NSSize(width: cfolders.imageNSSize.width + spacingSize().width, height: cfolders.imageNSSize.height + spacingSize().height)
        }
        func font() -> NSFont {
            return NSFont(name: generals.fontName, size: viewSize().width / 7)!
        }
        func textSize() -> NSSize {
            return NSSize(width: viewSize().width, height: font().capHeight * 2)
        }
    }
    
    struct ctabs {
        func height() -> CGFloat {
            return screenSize.height * 0.03
        }
    }
    
    init() {
        evalGeneral()
        evalFolder()
    }
    
    private func evalGeneral() {
        
        let fontName = defaults.string(forKey: defaultsKeys.general.fontName)
        if fontName != nil {
            generals.fontName = fontName
        } else {
            generals.fontName = "Avenir Next"
        }
        
//        let defaultString = defaults.string(forKey: defaultsKeys.general.fontName)
//        if defaultString != nil {
//            generals.defaultURL = URL(string: defaultString!)
//        } else {
//            generals.defaultURL = URL(fileURLWithPath: documentPath)
//        }
    }
    
    private func evalFolder() {
        
        let imageString = defaults.string(forKey: defaultsKeys.cfolder.imageSize)
        if imageString != nil {
            let imageSize = NSSizeFromString(imageString!)
            if imageSize == NSSize(width: 0, height: 0) {
                Swift.print("folderImage in userDefaults may contain improper data.")
            }
            cfolders.imageNSSize = imageSize // ambiguos didSet use
        } else {
            cfolders.imageNSSize = NSSize(width: screenSize.width / 20, height: (screenSize.width / 20) * 0.72)
        }        
    }
}

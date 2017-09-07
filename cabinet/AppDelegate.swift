//
//  AppDelegate.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/4/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

let dev = true

let screenSize = NSScreen.main()!.frame

struct flags {
    static var shift = false
    static var control = false
    static var option = false
    static var command = false
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        /* WINDOW SETTINGS */
        NSApp.windows.first?.titleVisibility = NSWindowTitleVisibility.hidden
        NSApp.windows.first?.titlebarAppearsTransparent = true // Title bar transparency
        NSApp.windows.first?.representedURL = nil // Hides file image in title bar
        NSApp.windows.first?.setIsZoomed(true) // Fullscreen on launch
        NSApp.windows.first?.acceptsMouseMovedEvents = true
        NSApp.windows.first?.backgroundColor = themeColors().secondary
        NSApp.windows.first?.minSize = NSSize(width: screenSize.width/3, height: screenSize.height/3)
        
        /* FLAGS */
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
            switch $0.modifierFlags.intersection(.deviceIndependentFlagsMask) {
            case [.shift]:
                flags.shift = true
            case [.control]:
                flags.control = true
            case [.option] :
                flags.option = true
            case [.command]:
                flags.command = true
            default:
                flags.shift = false
                flags.control = false
                flags.option = false
                flags.command = false
            }
            return $0
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Save anything needed, possibly save undo list
    }
}

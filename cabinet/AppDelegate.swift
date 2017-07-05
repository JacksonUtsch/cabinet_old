//
//  AppDelegate.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/4/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

public let dev = true
public let screenSize = NSScreen.main()!.frame

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        /* WINDOW SETTINGS */
        NSApp.windows.first?.titleVisibility = NSWindowTitleVisibility.hidden // Removes title
        NSApp.windows.first?.titlebarAppearsTransparent = true // Title bar transparency
        NSApp.windows.first?.setIsZoomed(true) // Fullscreen on launch
        NSApp.windows.first?.backgroundColor = Design.window.color
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

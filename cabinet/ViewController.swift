//
//  ViewController.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/4/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa


public var appLayout = layout()

var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if dev == true{ print("Screen Size: \(screenSize)") }

        var dir = FMDirectory(folderURL: URL(fileURLWithPath: documentPath))
        
        // get default directory (NSURL)
        // get list of files at this point
        // display based on viewing sys (organize by ..)
        
        let viewer = CFiles(frame: screenSize, path: URL(fileURLWithPath: documentPath + "/projects/software"))
        self.view.addSubview(viewer)
        
        
        let cp = CPath(frame: NSRect(x: 0, y: 0, width: screenSize.width, height: 100), path: URL(fileURLWithPath: documentPath + "/projects/software"))
        self.view.addSubview(cp)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }    
}

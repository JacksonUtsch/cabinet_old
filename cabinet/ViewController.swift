//
//  ViewController.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/4/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Cocoa

var appLayout = layout()
let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if dev == true{ print("Screen Size: \(screenSize)") }
        
        
        let viewer = CViewer(frame: screenSize, path: URL(fileURLWithPath: documentPath + "/projects/software")) // CFiles(frame: screenSize, path: URL(fileURLWithPath: documentPath + "/projects/software"))
        self.view.addSubview(viewer)
        
//        let pathView = CPath(frame: <#T##NSRect#>, path: <#T##URL#>)
    }
}





//        let cp = CPath(frame: NSRect(x: 0, y: 0, width: screenSize.width, height: 100), path: URL(fileURLWithPath: documentPath + "/projects/software"))
//        self.view.addSubview(cp)

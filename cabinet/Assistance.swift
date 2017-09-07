//
//  Assistance.swift
//  cabinet
//
//  Created by Jackson Utsch on 8/2/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import Foundation

enum caseType {
    case lower
//    case start
    case upper
}

func caseSubpaths(type: caseType, path:URL) { // not tested
    let dir = FMDirectory(folderURL: path)
    for item in dir.contentsOrderedBy(.Name, ascending: true) {
        var newPath = item.url.deletingLastPathComponent()
        if type == .lower {
            newPath = URL(fileURLWithPath: newPath.path + "/" + item.name.lowercased())
        }
//        if type == .start {
//            var thing = item.name.lowercased()
//            if thing.contains("%20") {
//                for char in thing.characters.enumerated() {
//                    if char.element == "%" {
//                        thing[char.offset + 3]
//                    }
//                }
//            }
//            newPath = URL(fileURLWithPath: newPath.path + "/" + thing)
//        }
//        if type == .upper {
//            newPath = URL(fileURLWithPath: newPath.path + "/" + item.name.uppercased())
//        }
//        if item.url != newPath {
//            do { try FileManager.default.moveItem(at: item.url, to: newPath) } catch { Swift.print(error) }
//        }
    }
}

func search(term:String, startPath:URL, depth:Int) -> [URL] {
    var urlList:[URL] = []
    let dir = FMDirectory(folderURL: startPath)
    for item in dir.contentsOrderedBy(.Name, ascending: true) {
        if item.isFolder {
            
        } else {
            if item.url.lastPathComponent.contains(term) {
                urlList += [item.url]
            }
        }
    }
    return urlList
}

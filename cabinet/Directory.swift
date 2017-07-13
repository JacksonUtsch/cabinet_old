/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import AppKit

// File Manager Tools

public let dirKey = "Directory"

public struct FMMetadata : CustomDebugStringConvertible , Equatable {
    
    let name:String
    let date:Date
    let size:Int64
    let icon:NSImage
    let color:NSColor
    let isFolder:Bool
    let url:URL
    
    init(fileURL:URL, name:String, date:Date, size:Int64, icon:NSImage, isFolder:Bool, color:NSColor ) {
        self.name  = name
        self.date = date
        self.size = size
        self.icon = icon
        self.color = color
        self.isFolder = isFolder
        url = fileURL
    }
    
    public var debugDescription: String {
        return name + " " + "Folder: \(isFolder)" + " Size: \(size)"
    }
    
}

//MARK:  Metadata  Equatable
public func ==(lhs: FMMetadata, rhs: FMMetadata) -> Bool {
    return (lhs.url == rhs.url)
}


public struct FMDirectory {
    
    fileprivate var files = [FMMetadata]()
    let url:URL
    
    public enum FileOrder : String {
        case Name
        case Date
        case Size
    }
    
    public init( folderURL:URL ) {
        url = folderURL
        let requiredAttributes = [URLResourceKey.localizedNameKey, URLResourceKey.effectiveIconKey,URLResourceKey.typeIdentifierKey,URLResourceKey.creationDateKey,URLResourceKey.fileSizeKey, URLResourceKey.isDirectoryKey,URLResourceKey.isPackageKey]
        if let enumerator = FileManager.default.enumerator(at: folderURL, includingPropertiesForKeys: requiredAttributes, options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants], errorHandler: nil) {
            
            while let url = enumerator.nextObject() as? URL {
                
                do{
                    
                    let properties = try  (url as NSURL).resourceValues(forKeys: requiredAttributes)
                    files.append(FMMetadata(fileURL: url,
                                            name: properties[URLResourceKey.localizedNameKey] as? String ?? "",
                                            date: properties[URLResourceKey.creationDateKey] as? Date ?? Date.distantPast,
                                            size: (properties[URLResourceKey.fileSizeKey] as? NSNumber)?.int64Value ?? 0,
                                            icon: properties[URLResourceKey.effectiveIconKey] as? NSImage  ?? NSImage(),
                                            isFolder: (properties[URLResourceKey.isDirectoryKey] as? NSNumber)?.boolValue ?? false,
                                            color: NSColor()))
                }
                catch {
                    print("Error reading file attributes")
                }
            }
        }
    }
    
    
    func contentsOrderedBy(_ orderedBy:FileOrder, ascending:Bool) -> [FMMetadata] {
        let sortedFiles:[FMMetadata]
        switch orderedBy
        {
        case .Name:
            sortedFiles = files.sorted{ return sortMetadata(lhsIsFolder:true, rhsIsFolder: true, ascending: ascending, attributeComparation:itemComparator(lhs:$0.name, rhs: $1.name, ascending:ascending)) }
        case .Size:
            sortedFiles = files.sorted{ return sortMetadata(lhsIsFolder:true, rhsIsFolder: true, ascending:ascending, attributeComparation:itemComparator(lhs:$0.size, rhs: $1.size, ascending: ascending)) }
        case .Date:
            sortedFiles = files.sorted{ return sortMetadata(lhsIsFolder:true, rhsIsFolder: true, ascending:ascending, attributeComparation:itemComparator(lhs:$0.date, rhs: $1.date, ascending:ascending)) }
        }
        return sortedFiles
    }
    
    func readMeta(data:[NSManagedObject]) -> [FMDirectory] {
        if data.count == 0 {
            Swift.print("sender has no data. FMDirectory.readMeta")
            return []
        }
        var dirList:[FMDirectory] = []
        for object in data {
            let URLString = object.value(forKey: dirKey) as! String
            dirList += [FMDirectory(folderURL: URL(fileURLWithPath: URLString))]
        }
        return dirList
    }
}

//MARK: - Sorting
func sortMetadata(lhsIsFolder:Bool, rhsIsFolder:Bool,  ascending:Bool , attributeComparation:Bool ) -> Bool
{
    if( lhsIsFolder && !rhsIsFolder) {
        return ascending ? true : false
    }
    else if ( !lhsIsFolder && rhsIsFolder ) {
        return ascending ? false : true
    }
    return attributeComparation
}

func itemComparator<T:Comparable>( lhs:T, rhs:T, ascending:Bool ) -> Bool {
    return ascending ? (lhs < rhs) : (lhs > rhs)
}


//MARK: NSDate Comparable Extension
extension Date {
    
}

public func ==(lhs: Date, rhs: Date) -> Bool {
    if lhs.compare(rhs) == .orderedSame {
        return true
    }
    return false
}

public func <(lhs: Date, rhs: Date) -> Bool {
    if lhs.compare(rhs) == .orderedAscending {
        return true
    }
    return false
}

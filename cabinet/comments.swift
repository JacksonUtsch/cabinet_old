
//    var path:URL = URL(fileURLWithPath: documentPath + "/projects/software") {
//        didSet {
//            viewer.path = path
//        }
//    }

//        let myView = CCollage(frame: screenSize, path: URL(fileURLWithPath: documentPath + "/images"))
//        self.view.addSubview(myView)

//        let path = URL(fileURLWithPath: documentPath + "/images")
//        let dir = FMDirectory(folderURL: path)
//        var imageArray:[NSImage] = []
//        for item in dir.contentsOrderedBy(.Name, ascending: true) {
//            do {
//                let data = try Data(contentsOf: item.url)
//                let image = NSImage(data: data)
//                if image != nil {
//                    imageArray += [image!] // sort by size? (WxH)
//                }
//            } catch {
//                Swift.print(error)
//            }
//        }
//
//        let myView = NSCollectionView(frame: screenSize) // PinterestLayout() // CCollage(frame: screenSize, path: URL(fileURLWithPath: documentPath + "/images"))
//        myView.collectionViewLayout = PinterestLayout()
//        self.view.addSubview(myView)
//        myView.content = imageArray

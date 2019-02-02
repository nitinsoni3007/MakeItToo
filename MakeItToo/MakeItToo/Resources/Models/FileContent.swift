//
//  FileImage.swift
//  MakeItToo
//
//  Created by Nitin on 31/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import Foundation

class FileContent {
    var crd = ""
    var folderId = ""
    var image = ""
    var imageBig = ""
    var imageId = ""
    var imageSmall = ""
    var userId = ""
    var imgData: Data?
    
    init(_ dict: [String: String]) {
        self.crd = dict["crd"]!
        self.folderId = dict["folderId"]!
        self.image = dict["image"]!
        self.imageBig = dict["imageBig"]!
        self.imageId = dict["imageId"]!
        self.imageSmall = dict["imageSmall"]!
        self.userId = dict["userId"]!
    }
}


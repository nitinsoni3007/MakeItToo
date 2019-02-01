//
//  Folder.swift
//  MakeItToo
//
//  Created by Nitin on 31/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import Foundation

class Folder {
    var crd: String?
    var folderId: String?
    var folderName : String?
    var userId : String?
    init(_ dict: [String: String]) {
        self.crd = dict["crd"]
        self.folderId = dict["folderId"]
        self.folderName = dict["folderName"]
        self.userId = dict["userId"]
    }
}

//{
//    crd = "2019-01-27 08:22:04";
//    folderId = 7;
//    folderName = fOne;
//    userId = 5;
//}

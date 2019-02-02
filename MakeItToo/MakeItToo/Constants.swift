//
//  Constants.swift
//  MakeItToo
//
//  Created by Nitin on 27/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import Foundation
import UIKit

struct GlobalConstants{
    static let USER_LOGGEDIN = "userLoggedIn"
    static let USER_NAME = "userName"
    static let USER_ID = "userId"
    static let AUTH_TOKEN = "authToken"
}

struct APIAction {
    static let REGISTER = "registratin"
    static let LOGIN = "login"
    static let CREATE_FOLDER = "folder/createFolder"
    static let UPLOAD_FILE = "folder/uploadImage"
    static let GET_FOLDERS = "folder/getFolder"
    static let GET_CONTENTS = "folder/getImage?folderId="
}

let themeColor = UIColor(red: 193/255.0, green: 8/255.0, blue: 20/255.0, alpha: 1.0)
let themeLightColor = UIColor(red: 197/255.0, green: 98/255.0, blue: 114/255.0, alpha: 1.0)
//ttp://swint.co.md-76.webhostbox.net/makeittoo/index.php/service/folder/uploadImage

//registration :

//userName:aishwary
//* email:aish@gmail.com
//* password:123456
//* phoneNumber:8982077519
//* address:indiore
//deviceType:1
//deviceToken:dfg68df4gdf56g4d6fg46df5g46df5g4d5f64


//login :

//email:aish@gmail.com
//* password:123456


//createFolder:

//folderName:new2


//uploadImage:

//folderId:4
//image:


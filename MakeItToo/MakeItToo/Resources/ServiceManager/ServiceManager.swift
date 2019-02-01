//
//  ServiceManager.swift
//  MakeItToo
//
//  Created by Nitin on 27/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import Foundation
import Alamofire

let BASE_URL = "http://swint.co.md-76.webhostbox.net/makeittoo/index.php/service/"

class ServiceManager {
    static let sharedManager = ServiceManager()
    func callAPI(_ action:String, method: String, params: [String: String], success:@escaping((_ response: [String:AnyObject]) -> ()), failure: @escaping((_ failReason: String) -> ())) {
        let urlStr = BASE_URL + action
        print("action = \(action)")
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = method
        if method == "POST" {
        var str = ""
        for (key, value) in params {
            str = str + key + "=" + value + "&"
        }
        str = String(str.dropLast())
        request.httpBody = str.data(using: .utf8)!
        }
        if action != APIAction.LOGIN && action != APIAction.REGISTER {
            print("auth token = \(UserDefaults.standard.value(forKey: GlobalConstants.AUTH_TOKEN) as! String)")
            request.addValue(UserDefaults.standard.value(forKey: GlobalConstants.AUTH_TOKEN) as! String, forHTTPHeaderField: "authToken")
        }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request){ (data, response, err) in
            if data == nil {
                failure("some error occurred")
                return
            }
            do {
                
            let jsonObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                if let respCode = (jsonObj as! [String: AnyObject])["responseCode"] as? Int {
                    if respCode == 300 {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "logMeOut"), object: nil)
                        }
                    }
                }
                else {
                success(jsonObj as! [String: AnyObject])
                }
            }catch {
                failure("some issue occurred")
            }
        }
        
        dataTask.resume()
        
    }
    
    func uploadImageNew(_ imageData: Data, folderId: String, callBack: @escaping((_ response: [String: AnyObject]?) -> ())) {

        let parameters = ["folderId":folderId]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "image", fileName: "image242.png", mimeType: "image/png")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: BASE_URL + APIAction.UPLOAD_FILE,
           headers: ["authToken": UserDefaults.standard.value(forKey: GlobalConstants.AUTH_TOKEN) as! String]) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { progress in
                    print("prog = \(progress.fractionCompleted)")
                }
                upload.validate()
                upload.responseJSON { response in
                    print("response = \(response)")
                    guard response.result.isSuccess,
                        let value = response.result.value else {
                            print("Error while uploading file: \(String(describing: response.result.error))")
                            callBack(nil)
                            return
                    }

                    // 2
//                    let firstFileID = JSON(value)["uploaded"][0]["id"].stringValue
                    print("Content uploaded with folder ID: \(folderId)")

                    //3
                    do {
                    let jsonObj = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    }catch {
                        
                    }
                    callBack(["result":"success" as AnyObject])
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
}

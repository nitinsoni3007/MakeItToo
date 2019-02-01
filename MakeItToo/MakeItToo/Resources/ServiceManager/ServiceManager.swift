//
//  ServiceManager.swift
//  MakeItToo
//
//  Created by Nitin on 27/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import Foundation

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
    
    func uploadImage(_ imageData: Data, folderId: String, callBack: @escaping((_ response: [String: AnyObject]) -> ())) {
        var request = URLRequest(url: URL(string: BASE_URL + APIAction.UPLOAD_FILE)!)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        request.addValue(UserDefaults.standard.value(forKey: GlobalConstants.AUTH_TOKEN) as! String, forHTTPHeaderField: "authToken")
//        let image = UIImage(named: "man.png")
//        guard let imageData = image!.pngData() else {
//            print("oops")
//            return
//        }

//        let CRLF = "\r\n"
//        let filename = "user.png"
//        let formName = "file"
//        let type = "image/png"     // file type
//
//        let boundary = String(format: "----iOSURLSessionBoundary.%08x%08x", arc4random(), arc4random())
//
//        var body = Data()
//
//        let parameterDict :[String:String] = ["folderId":folderId]
//
//
//        // let parameterDict :[String:String] = ["product_id":"","title":"1","description":"hhhhhhh","price":"21","old_price":"12","shop_categorie":"11","quantity":"1","user_id":"31","min_buy":"1","model_number":"12","product_type":"","price_type":"wholesale","brand_name":"sports"]
//
////        for i in 0 ..< self.arrImages.count {
//        let timeStamp = Date().timeIntervalSince1970
//            body.append(("--\(boundary)" + CRLF).data(using: .utf8)!)
//            body.append(("Content-Disposition: form-data; name=\"image\" filename=\"image_fID_\(folderId).png\"" + CRLF).data(using: .utf8)!)// name=\"\("userfile[]")\";
//            body.append(("Content-Type: \(type)" + "\r\n" + "\r\n").data(using: .utf8)!)
////            let imageData = self.arrImages[i].pngData()!
//            body.append(imageData as Data)
//            body.append("\r\n".data(using: .utf8)!)
//            body.append(("--\(boundary)--" + CRLF).data(using: .utf8)!)
////        }
//
//        for (key, value) in parameterDict {
//            body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//            body.append("\(value)".data(using: String.Encoding.utf8)!)
//            body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//        }
//
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        //TW debug the body data.
//        //        let theString:NSString = NSString(data: body as Data, encoding: String.Encoding.ascii.rawValue)!
//        //        print(theString)
//
//        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")

        request.httpBody = self.createRequestBodyWith(parameters: ["folderId":folderId], imageData: imageData, filePathKey: "image1", boundary: self.generateBoundaryString()) as Data
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
//            callBack([String:AnyObject]())
            if let error = error {
                print(error)

            }
            if let respose = response {
                print(respose)



            }
            // TW
            if let data = data {
                // This gives us same as server log
                // You can print out response object
                print("*** response = \(String(describing: response))")
                print(data.count)
                // you can use data here
                // Print out reponse body
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("** response data = \(responseString!)")


                DispatchQueue.main.async {
//                    LoadingView.shared.hideOverlayView()
//                    self.navigationController?.popViewController(animated: true)
                }

            }
            }

            dataTask.resume()
    }
    
    //request.httpBody = self.createRequestBodyWith(parameters:yourParamsDictionary, filePathKey:yourKey, boundary:self.generateBoundaryString)

    
    func createRequestBodyWith(parameters:[String:String], imageData: Data, filePathKey:String, boundary:String) -> NSData{
        
        let body = NSMutableData()
        body.appendString(string: "Content-Type: multipart/form-data; --\(boundary)\r\n")
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = "myImage.jpg"
        
//        let imageData = UIImageJPEGRepresentation(yourImage, 1)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        print("appending str = \(string)")
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

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
            request.addValue(UserDefaults.standard.value(forKey: GlobalConstants.AUTH_TOKEN) as! String, forHTTPHeaderField: "authToken")
        }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request){ (data, response, err) in
            do {
                let responseStr = String.init(data: data!, encoding: .utf8)
            let jsonObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                success(jsonObj as! [String: AnyObject])
            }catch {
                failure("some issue occurred")
            }
        }
        
        dataTask.resume()
        
    }
}

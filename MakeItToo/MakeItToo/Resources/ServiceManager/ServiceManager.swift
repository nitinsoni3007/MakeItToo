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
    func callAPI(_ action:String, params: [String: AnyObject], success:((_ response: [String:AnyObject]) -> ())) {
        let urlStr = BASE_URL + action
        let url = URL(string: urlStr)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url!) { (data, response, err) in
            do {
            let jsonObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                
            }catch {
                
            }
        }
        
        dataTask.resume()
        
    }
}

//
//  LoginNav.swift
//  MakeItToo
//
//  Created by Nitin on 27/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

protocol LoginNavDelegate {
    func userLoggedIn()
}

class LoginNav: UINavigationController {
    var loginDelegate: LoginNavDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

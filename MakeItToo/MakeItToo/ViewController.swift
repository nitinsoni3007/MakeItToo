//
//  ViewController.swift
//  MakeItToo
//
//  Created by Nitin on 26/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LoginNavDelegate {
    var loginNav: LoginNav!
    var containerVC: ContainerViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(logMeOut), name: NSNotification.Name.init(rawValue: "logMeOut"), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func logMeOut() {
        UserDefaults.standard.set(false, forKey: GlobalConstants.USER_LOGGEDIN)
        if containerVC != nil {
            containerVC!.view.removeFromSuperview()
            containerVC!.removeFromParentViewController()
            containerVC = nil
        }
        showLoginView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: GlobalConstants.USER_LOGGEDIN) {
            showHome()
        }else {
            showLoginView()
        }
    }
    
    func showLoginView() {
        loginNav = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! LoginNav
        loginNav.loginDelegate = self
        self.addChildViewController(loginNav)
        self.view.addSubview(loginNav.view)
        loginNav.didMove(toParentViewController: self)
    }
    
    func showHome() {
        if containerVC == nil {
        containerVC = self.storyboard?.instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController
        self.addChildViewController(containerVC!)
        self.view.addSubview(containerVC!.view)
        containerVC!.didMove(toParentViewController: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Login nav delegate
    func userLoggedIn() {
        loginNav.view.removeFromSuperview()
        loginNav.removeFromParentViewController()
        showHome()
    }

}


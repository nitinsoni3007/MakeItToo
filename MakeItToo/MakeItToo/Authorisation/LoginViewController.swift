//
//  LoginViewController.swift
//  MakeItToo
//
//  Created by Nitin on 26/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        (self.navigationController as! LoginNav).loginDelegate?.userLoggedIn()
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        let registrationVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

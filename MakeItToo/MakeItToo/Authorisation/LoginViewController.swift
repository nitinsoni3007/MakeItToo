//
//  LoginViewController.swift
//  MakeItToo
//
//  Created by Nitin on 26/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        if areDataValid() {
        ServiceManager.sharedManager.callAPI(APIAction.LOGIN, method: "POST", params: ["email":txtEmail.text!,"password":txtPassword.text!], success: { (response) in
            if response["status"] as! String == "success" {
                let userData = response["data"] as! [String: AnyObject]
            UserDefaults.standard.set(true, forKey: GlobalConstants.USER_LOGGEDIN)
            UserDefaults.standard.set(userData["userName"] as! String, forKey: GlobalConstants.USER_NAME)
            UserDefaults.standard.set(userData["userId"] as! String, forKey: GlobalConstants.USER_ID)
            UserDefaults.standard.set(userData["authToken"] as! String, forKey: GlobalConstants.AUTH_TOKEN)
            DispatchQueue.main.async {
                (self.navigationController as! LoginNav).loginDelegate?.userLoggedIn()
            }
            }
        }) { (reasonStr) in
            print("response = \(reasonStr)")
        }
        }
    }
    
    func areDataValid() -> Bool {
        var msg = ""
        if let emailStr = txtEmail.text{
            let emailAdd = emailStr.trimmingCharacters(in: .whitespaces)
            if !emailAdd.isValidEmail(){
                msg = "Email is not valid"
            }
        }
        if let password = txtPassword.text {
            if password.count < 5 && password.count > 12{
                msg = "Password must be 5 to 12 characters long"
            }
        }
        if msg.count > 0 {
            self.showAlert(title: nil, message: msg)
            return false
        }
        return true
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        let registrationVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    //touch delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

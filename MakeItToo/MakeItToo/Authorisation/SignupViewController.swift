//
//  SignupViewController.swift
//  MakeItToo
//
//  Created by Nitin on 26/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRegistrationAction(_ sender: Any) {
        if areDataValid() {
            ServiceManager.sharedManager.callAPI(APIAction.REGISTER, method: "POST", params: ["userName":txtName.text!,"address":txtAddress.text ?? "", "phoneNumber":txtPhone.text!,"email":txtEmail.text!,"password":txtPassword.text!, "deviceType": "1", "deviceToken": "dfg68df4gdf56g4d6fg46df5g46df5g4d5f65"], success: { (response) in
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
        if let name = txtName.text {
           let username = name.trimmingCharacters(in: .whitespaces)
            if username.count == 0{
                msg = "Name must not be blank"
            }
        }else if let phone = txtPhone.text {
            if phone.count < 10{
                msg = "Invalid Phone number"
            }
        }else if let emailStr = txtEmail.text{
            let emailAdd = emailStr.trimmingCharacters(in: .whitespaces)
            if !emailAdd.isValidEmail(){
                msg = "Email is not valid"
            }
        }else if let password = txtPassword.text {
            if password.count < 5 && password.count > 12{
                msg = "Password must be 5 to 12 characters long"
            }
        }else if let confirmPass = txtConfirmPassword.text {
            if txtPassword.text! != confirmPass {
                msg = "Passwords do not match, please re-enter password and confirm the same"
            }
        }
        
        if msg.count > 0 {
            self.showAlert(title: nil, message: msg)
            return false
        }
        return true
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: touches delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

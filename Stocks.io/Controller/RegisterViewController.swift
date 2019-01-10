//
//  RegisterViewController.swift
//  Stocks.io
//
//  Created by Craig Scott on 1/5/19.
//  Copyright © 2019 Craig Scott. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var first_name: LoginTextField!
    
    @IBOutlet weak var last_name: LoginTextField!
    @IBOutlet weak var email: LoginTextField!
    @IBOutlet weak var RegisterActivity: UIActivityIndicatorView!
    @IBOutlet weak var password: LoginTextField!
    @IBOutlet weak var password_verify: LoginTextField!
    @IBAction func GoToLoginButton(_ sender: Any) {
        
        dismiss(animated: true, completion:nil)
        if let login = self.presentingViewController as? LoginViewController{
            login.LoginContainer.isHidden = false
        }
        
        /*
        if let nav = self.navigationController{
            for vc in nav.viewControllers{
                if let login = vc as? LoginViewController{
                    login.LoginContainer.isHidden = false
                }
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        */
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RegisterActivity.hidesWhenStopped = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        
        setupHideKeyboardOnTap()

        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @IBAction func Register(_ sender: Any) {
        RegisterActivity.startAnimating()
        
        let body = [
            "username" : email.text,
            "email" : email.text,
            "password" : password.text,
            "first_name" : first_name.text,
            "last_name" : last_name.text
        ]
        
        Alamofire.request(backendConstants.deploymentURL + "users/register/", method: .post, parameters: body,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                self.RegisterActivity.stopAnimating()
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos/1")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("\(response.result.value)")
                    return
                }
                
                
        }
    
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let login = segue.destination as? LoginViewController{
            login.LoginContainer.isHidden = false
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

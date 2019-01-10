//
//  LoginViewController.swift
//  Stocks.io
//
//  Created by Craig Scott on 1/4/19.
//  Copyright © 2019 Craig Scott. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController , UINavigationControllerDelegate{
    private var user_profile : Profile = Profile(first_name: "", last_name: "", email: "", Token: "", Stocks: [])
    @IBOutlet weak var LoginContainer: RoundedView!
    @IBOutlet weak var email_textfield: LoginTextField!
    
    @IBOutlet weak var password_textfield: LoginTextField!
    @IBOutlet weak var login_activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login_activity.hidesWhenStopped = true
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
        //LoginContainer.isHidden = false
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
    
    override func awakeFromNib() {
    }
    

    @IBAction func RegisterButton(_ sender: Any) {
        LoginContainer.isHidden = true
        performSegue(withIdentifier: "RegisterSegue", sender: self.navigationController)
        //let sVC = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        
        //self.navigationController?.pushViewController(sVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Auth-token login
    @IBAction func login_auth_token(_ sender: Any) {
        login_activity.startAnimating()
        let body = [
            "username" : email_textfield.text,
            "password" : password_textfield.text
        ]
        
        Alamofire.request(backendConstants.deploymentURL + "users/token/", method: .post, parameters: body,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                self.login_activity.stopAnimating()
                
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
                if let token = json["token"] as? String {
                    print(token)
                    self.user_profile.Token = token
                    self.performSegue(withIdentifier: "LoginSegue", sender: self.navigationController)
                    print("Success")
                }else{
                    print("Invalid Login Information")
                }
                
        }
    }
    

}

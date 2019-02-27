//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Khaled H on 06/02/2019.
//  Copyright © 2019 Khaled H. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotificationsObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotificationsObserver()
    }
    

    @IBAction func loginButton(_ sender: Any) {
        guard let email = self.emailTextField.text else{
            showAlert(title: "Email Cannot Be Empty", message: "Please Enter Your Email")
            return
        }
        
        guard let password = self.passwordTextField.text else{
            
            showAlert(title: "Password Cannot Be Empty", message: "Please Enter Your Password")
            return
        }
        
        self.varifyUser(email, password)
        
    }
    
    
    
    func varifyUser(_ email: String, _ password: String) {
        let ai = startAnActivityIndicator()
        APIs.postRequest(username: email, password: password) { (errString) in
            ai.stopAnimating()
            guard errString == nil else {
                self.showAlert(title: "Error", message: errString!)
                return
            }
            DispatchQueue.main.async {
                print("Its successsssssssssssss")
                self.performSegue(withIdentifier: "showMap", sender: nil)
            }
        }

    }
    

}

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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButton(_ sender: Any) {
        
        guard let email = self.emailTextField.text else{
            let alert = UIAlertController(title: "Email Cannot Be Empty", message: "Please Enter Your Email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let password = self.passwordTextField.text else{
            let alert = UIAlertController(title: "Password Cannot Be Empty", message: "Please Enter Your Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.varifyUser(email, password)
        
    }
    
    
    
    func varifyUser(_ email: String, _ password: String) {
        
    }
    

}

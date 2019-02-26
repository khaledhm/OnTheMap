//
//  ContainerViewController.swift
//  OnTheMap
//
//  Created by Khaled H on 26/02/2019.
//  Copyright © 2019 Khaled H. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var locationsData: LocationsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadStudentLocations()
    }
    
    func setupUI() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocationTapped(_:)))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshLocationsTapped(_:)))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutTapped(_:)))
        
        navigationItem.rightBarButtonItems = [plusButton, refreshButton]
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc private func addLocationTapped(_ sender: Any) {
        let navController = UIStoryboard(name: "Application", bundle: nil).instantiateViewController(withIdentifier: "addLocation") as! UIViewController
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func refreshLocationsTapped(_ sender: Any) {
        loadStudentLocations()
    }
    
    @objc private func logoutTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            APIs.deleteSession{(err) in
                guard err == nil else{
                    self.showAlert(title: "Error", message: "err!")
                    return
                }
                print("logout tapped!!!!!")
                self.dismiss(animated: true, completion: nil)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController,animated: true,completion: nil)
        
        
    }
    
    private func loadStudentLocations() {
        let ai = self.startAnActivityIndicator()
        APIs.Parser.getStudentLocations { (data) in
            
            ai.stopAnimating()
            guard let data = data else {
                self.showAlert(title: "Error", message: "No internet connection found")
                return
            }
            guard data.studentLocations.count > 0 else {
                self.showAlert(title: "Error", message: "No pins found")
                return
            }
            self.locationsData = data
        }
    }
    
}

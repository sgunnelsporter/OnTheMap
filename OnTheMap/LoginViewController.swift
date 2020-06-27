//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewState(isViewClickable: true)
    }

    @IBAction func loginRequested(_ sender: Any) {
        self.updateViewState(isViewClickable: false)
    }
    
    func updateViewState(isViewClickable: Bool) -> Void {
        loginButton.isEnabled = isViewClickable
        emailTextField.isEnabled = isViewClickable
        passwordTextField.isEnabled = isViewClickable
        if !isViewClickable {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}


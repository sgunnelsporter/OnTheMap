//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Load View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewState(isViewClickable: true)
    }

    //MARK: Log-in
    @IBAction func loginRequested(_ sender: Any) {
        self.updateViewState(isViewClickable: false)
        UdacityAPI.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLogInResponse(success:error:))
        
    }
    //MARK: Supporting Network Functions
    
    func postUdacitySession() -> Void {
        
    }
    
    //MARK: Completion Handlers
    func handleLogInResponse(success: Bool, error: Error?) {
        if success {
            // get user public data
            UdacityAPI.getUserInformationRequest(completion: confirmLogIn(success:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func confirmLogIn(success: Bool, error: Error?) {
        if success {
            print("Got User Info for: \(UserSession.firstName)")
            performSegue(withIdentifier: "LogInSuccessSegue", sender: self)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    
    //MARK: Supporting View Fuctions
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
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
        updateViewState(isViewClickable: true)
    }
  
}


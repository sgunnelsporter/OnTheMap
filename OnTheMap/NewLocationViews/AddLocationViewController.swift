//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    let confirmMapLocationSegueId = "confirmMapLocationSegue"
    var newLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var errorLabelView: UILabel!
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorLabelView.isHidden = true
    }

    //MARK: Location Button Pressed
    @IBAction func findLocationRequest(_ sender: Any) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.locationTextField.text ?? "", completionHandler: { (placemark, error) in
            if error != nil {
                self.showErrorAlert(error!.localizedDescription)
            } else {
                if let newPlacemark = placemark?.first, let newLoc = newPlacemark.location?.coordinate {
                    self.newLocation = newLoc
                    self.performSegue(withIdentifier: self.confirmMapLocationSegueId, sender: self)
                } else {
                    print("Error in digging for Coordinate!")
                }
            }
        })
        
    }
    //MARK: cancel
    @IBAction func cancelNewLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    //MARK: Error Alert
    func showErrorAlert(_ message: String) {
        self.errorLabelView.text = "ERROR: \(message)"
        self.errorLabelView.isHidden = false
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.confirmMapLocationSegueId {
            
            let controller = segue.destination as! ConfirmLocationViewController
            controller.newLocation = self.newLocation
            controller.newLocationString = self.locationTextField.text ?? ""
            controller.newLocationURL = URL(string: self.urlTextField.text ?? "")
        }
    }

}

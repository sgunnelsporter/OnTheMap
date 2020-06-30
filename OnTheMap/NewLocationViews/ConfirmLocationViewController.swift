//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {

    //MARK: Map Data
    var newLocation = CLLocationCoordinate2D()
    var newLocationString = ""
    var newLocationURL = URL(string: "")
    var proposedAnnotation = MKPointAnnotation()

    //MARK: Outlets
    @IBOutlet weak var confirmMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate
        self.confirmMapView.delegate = self
        //build annotation
        self.proposedAnnotation.coordinate = self.newLocation
        self.proposedAnnotation.title = newLocationString
        self.proposedAnnotation.subtitle = newLocationURL?.absoluteString
        //set annotation on map view
        self.confirmMapView.addAnnotations([proposedAnnotation])
    }
    

    @IBAction func finishAndPost(_ sender: Any) {
        // post new student location
        UdacityAPI.postNewStudenLocation(newLatitude: self.newLocation.latitude, newLongitude: self.newLocation.longitude, locationString: self.newLocationString, locationMediaURL: self.newLocationURL?.absoluteString ?? "",  completion: {(results, error) in
            if error != nil {
                // handle error
            } else {
                // handle results
            }
        })
        // update map data
        UdacityAPI.getMapDataRequest(completion: { (studentLocationsArray, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                MapPins.mapPins = studentLocationsArray
            }
        })

        // go back to exitings pin view
        self.dismiss(animated: true, completion: {})
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

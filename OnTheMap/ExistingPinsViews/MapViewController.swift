//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    //MARK: Map Data Variables
    var locations = [LocationResults]()
    var annotations = [MKPointAnnotation]()
    let annotationReuseId = "pin"
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        if MapPins.mapPins.isEmpty {
            self.loadMapData()
        }
    }
    
    //MARK: MapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: self.annotationReuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: self.annotationReuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let urlToOpen = URL(string: view.annotation?.subtitle! ?? "") {
               UIApplication.shared.open(urlToOpen)
            }
        }
    }
    
    
    //MARK: Displaying Map Data
    func translateDictionaryToAnnotations(){
        for loc in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(loc.latitude)
            let long = CLLocationDegrees(loc.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(loc.firstName) \(loc.lastName)"
            annotation.subtitle = loc.mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
    }
    //MARK: Actions
    @IBAction func refreshDataFromNetwork(_ sender: Any) {
        self.loadMapData()
    }
    
    func loadMapData() {
        UdacityAPI.getMapDataRequest(completion: { (studentLocationsArray, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                MapPins.mapPins = studentLocationsArray
                self.locations = MapPins.mapPins
                self.translateDictionaryToAnnotations()
                //UdacityAPI.getMapDataRequest(completion: loadLocationsIntoMapAnnotations(mapData: error:))
                self.mapView.addAnnotations(self.annotations)
            }
        })
    }


}

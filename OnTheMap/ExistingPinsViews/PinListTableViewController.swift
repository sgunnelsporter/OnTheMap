//
//  PinListTableViewController.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import UIKit

class PinListTableViewController: UITableViewController {

    var locations = [LocationResults]()

    //MARK: Loading functions
    override func viewDidLoad() {
        super.viewDidLoad()
        if MapPins.mapPins.isEmpty {
            self.loadMapData()
        }
        self.locations = MapPins.mapPins
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Table view data source
    func loadMapData() {
        UdacityAPI.getMapDataRequest(completion: { (studentLocationsArray, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                MapPins.mapPins = studentLocationsArray
            }
        })
    }
    
    //MARK: Table View Control
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapPinCell", for: indexPath)
        cell.textLabel?.text = "\(self.locations[indexPath.row].firstName) \(self.locations[indexPath.row].lastName)"
        cell.detailTextLabel?.text = "\(self.locations[indexPath.row].mediaURL)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlToOpen = URL(string: self.locations[indexPath.row].mediaURL) {
           UIApplication.shared.open(urlToOpen)
        }
    }
    
    //MARK: Refresh Button
    @IBAction func refreshMapData(_ sender: Any) {
        self.loadMapData()
        self.locations = MapPins.mapPins
        self.tableView.reloadData()
    }
    

}

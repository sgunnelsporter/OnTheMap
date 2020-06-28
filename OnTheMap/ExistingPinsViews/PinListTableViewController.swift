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

    override func viewDidLoad() {
        super.viewDidLoad()
        if MapPins.mapPins.isEmpty {
            self.loadMapData()
        } else {
            self.locations = MapPins.mapPins
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    func loadMapData() {
        UdacityAPI.getMapDataRequest(completion: { (studentLocationsArray, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                MapPins.mapPins = studentLocationsArray
                self.locations = MapPins.mapPins
            }
        })
    }
    
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

}

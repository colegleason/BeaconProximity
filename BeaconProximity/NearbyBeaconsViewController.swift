//
//  NearbyBeaconsViewController.swift
//  BeaconProximity
//
//  Created by Cole Gleason on 12/8/17.
//  Copyright © 2017 Cole Gleason. All rights reserved.
//

import UIKit
import CoreLocation

// This class manages all UI code and scanning for beacons at the moment.
class NearbyBeaconsViewController: UIViewController {
    @IBOutlet weak var beaconTable: UITableView? // where beacons will be displayed
    @IBOutlet weak var scanSwitch: UISwitch? // turn scanning on and off
    @IBOutlet weak var scanLabel: UILabel? // The text next to the switch

    var recentBeacons: [CLBeacon] = [] // This array contains the beacons that will show up in the table.
    var beaconRegion: CLBeaconRegion =
        CLBeaconRegion(proximityUUID: UUID.init(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!,
                       major: 555,
                       identifier: "winchester") // This specifies which beacons to look for. All beacons at WT have same UUID and major id
    var locationManager: CLLocationManager = CLLocationManager() // The location manager handles ranging of beacons.

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self // Location manager callbacks will go to class extension below.
        self.locationManager.requestWhenInUseAuthorization() // This pops up that permission window. We need permission to range for beacons.
        self.beaconTable?.delegate = self // Table callbacks will go to class extension below.
        self.beaconTable?.dataSource = self // This class is responsible for the data that will fill the table.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // On switch flip, toggle beacon ranging on or off.
    @IBAction func onScanSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
            scanLabel?.text = "Scanning: On"
        } else {
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
            scanLabel?.text = "Scanning: Off"
        }
    }
}

// All callbacks for the Location Manager
extension NearbyBeaconsViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    // Called when beacons are nearby
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        recentBeacons.removeAll() // Empty our data array
        recentBeacons.append(contentsOf: beacons) // refill it with latest sensed beacons
        beaconTable?.reloadData() // Tell the table to reload using new data.
    }
}

extension NearbyBeaconsViewController : UITableViewDataSource, UITableViewDelegate {
    // How many sections are in our table. Just one for now.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // How many rows are in our table. Just the length of the data array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentBeacons.count
    }
    
    // This returns a string for values of the beacon proximity measure.
    func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        }
    }
    
    // This sets the text for each row in the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beaconCell")!
        
        let beacon = recentBeacons[indexPath.row]
        let accuracy = String(format: "%.2f", beacon.accuracy)
        let text = "Beacon \(beacon.minor), \(nameForProximity(beacon.proximity)) (approx. \(accuracy)m)"
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

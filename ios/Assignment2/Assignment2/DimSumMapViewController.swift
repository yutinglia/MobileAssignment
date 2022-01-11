//
//  DimSumMapViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 12/1/2022.
//

import UIKit
import MapKit
import CoreLocation

class DimSumMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManger : CLLocationManager?;
    
    var coordinate: CLLocationCoordinate2D? = nil;
    
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(CLLocationManager.locationServicesEnabled()){
            print("locationServicesEnabled");
            self.locationManger = CLLocationManager();
            self.locationManger?.delegate = self;
            if(self.locationManger?.authorizationStatus != .authorizedAlways){
                print("!authorizedAlways");
                self.locationManger?.requestAlwaysAuthorization();
            }else{
                print("authorizedAlways");
                self.initLocationManger();
            }
        }else{
            print("oof");
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if(manager.authorizationStatus == .authorizedAlways){
            self.initLocationManger();
        }
    }
    
    func initLocationManger(){
        print("initLocationManger");
        self.locationManger?.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManger?.distanceFilter = kCLDistanceFilterNone;
        self.locationManger?.startUpdatingLocation();
        self.coordinate = locationManger?.location?.coordinate;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.coordinate = location.coordinate;
        }
    }
    
    func showCurrentLocation(){
        guard let coordinate = coordinate else {
            print("no coor");
            return
        }
        let region = MKCoordinateRegion(center: coordinate, span: span);
        self.mapView?.setRegion(region, animated: true);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCurrentLocation();
    }

}

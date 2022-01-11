//
//  AddStoreViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 12/1/2022.
//

import UIKit
import MapKit
import CoreLocation

class AddStoreViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tfLat: UITextField!
    @IBOutlet weak var tfLong: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvIntro: UITextView!
    @IBOutlet weak var tfAddress: UITextField!
    
    var locationManger : CLLocationManager?;
    
    var lat: Double = 0.0;
    var long: Double = 0.0;
    
    var coordinate: CLLocationCoordinate2D? = nil;
    var pointAnnotation: MKPointAnnotation = MKPointAnnotation();
    
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
        self.lat = locationManger?.location?.coordinate.latitude ?? 0.0;
        self.long = locationManger?.location?.coordinate.longitude ?? 0.0;
        self.tfLat.text = "\(self.lat)";
        self.tfLong.text = "\(self.long)";
        self.coordinate = locationManger?.location?.coordinate;
        self.pointAnnotation.coordinate = self.coordinate!;
        self.pointAnnotation.title = "New Store";
        self.mapView.addAnnotation(self.pointAnnotation);
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.lat = location.coordinate.latitude;
            self.long = location.coordinate.longitude;
            self.coordinate = location.coordinate;
        }
    }
    
    func showCurrentLocation(){
        guard let coordinate = coordinate else {
            return
        }
        let region = MKCoordinateRegion(center: coordinate, span: span);
        self.mapView?.setRegion(region, animated: true);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: mapView);
            let location = mapView.convert(touchPoint, toCoordinateFrom: mapView);
            self.tfLat.text = "\(location.latitude)";
            self.tfLong.text = "\(location.longitude)";
            self.pointAnnotation.coordinate = location;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCurrentLocation();
    }
    
    @IBAction func btnGPSClick(_ sender: Any) {
        tfLat.text = "\(lat)";
        tfLong.text = "\(long)";
        self.pointAnnotation.coordinate = self.coordinate!;
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        addStore(lat: Double(tfLat.text!)!, long: Double(tfLong.text!)!, name: tfName.text!, intro: tvIntro.text!, address: tfAddress.text!, handler: {
            result in
            if(result.status == 0){
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Success", msg: result.msg, callback: {
                        self.dismiss(animated: true, completion: nil);
                    });
                }
            }else{
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Fail", msg: result.msg, callback: nil);
                }
            }
        })
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
}

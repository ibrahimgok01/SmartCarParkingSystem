//
//  parkMap.swift
//  Otopark_Takip_Sistemi
//
//  Created by Ibrahim Gok on 26.01.2022.
//

import UIKit
import MapKit
import CoreLocation

class MyAnnotation : MKPointAnnotation {
    var customHospitalId : String?
}

class parkMap: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenProvince = String()
    var latitude = Double()
    var longitude = Double()
    var ParkName = String()
    var ParkID = String()
    var emptySpace = String()
    
    let locationManager = CLLocationManager()
    
    var datas = loadCSV(from: "txt")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        if datas.count > 0 {
                for data in datas {
                    if data.il == chosenProvince {
                      
                                if let latitude_data = Double(data.latitude)  {
                                    
                                    latitude = latitude_data
                                    
                                }
                                if let longitude_data = Double(data.longitude) {
                                    
                                    longitude = longitude_data
                                    // Otopark boylamının veri tabanından çekilemsi.
                                }
                                if let parkisim_data = String?(data.park_ismi) {
                                    ParkName = parkisim_data
                                }
                                if let parkID_data = String?(data.id) {
                                    ParkID = parkID_data
                                }
                                let location = CLLocationCoordinate2D(latitude: latitude  , longitude: longitude )
                                print(location)
                                let annotation: MyAnnotation = MyAnnotation()
                                annotation.customHospitalId = ParkID
                                annotation.coordinate = location
                                annotation.title = "\(ParkName)"
                                emptySpace = data.emptySpace
                                annotation.subtitle = "Boş Park Yeri: \(emptySpace)"
                        
                                mapView.addAnnotation(annotation)
                        
                        }
                    }
                }
            }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Kullanıcı konumunun alınması
       
       let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
       let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
       let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Konumum"
        mapView.addAnnotation(annotation)
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Harita üzerindeki pin işaretinin özelleştirilmesi.
        if annotation is MKUserLocation {
            return nil
        }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if pinView == nil {
            
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            pinView?.canShowCallout = true
            pinView?.tintColor = .red
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) { // Navigasyon özelliğinin eklenmesi.
        
        let annotation = view.annotation as? MyAnnotation
        
        for data in datas {
            if annotation?.customHospitalId == data.id {
                if let latitude_data = Double(data.latitude)  {
                    latitude = latitude_data
                }
                if let longitude_data = Double(data.longitude) {
                    longitude = longitude_data
                }
                
                if let parkName_data = String?(data.park_ismi) {
                    ParkName = parkName_data
                }
            }
        }
        
        let requestLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarkDizisi, error in
            
            if let placemarks = placemarkDizisi {
                if placemarks.count > 0 {
                 let yeniPLacemark = MKPlacemark(placemark: placemarks[0])
                    let item  = MKMapItem(placemark: yeniPLacemark)
                    item.name = self.ParkName
                    
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
            
        }
    }
        
        
        
        
    }





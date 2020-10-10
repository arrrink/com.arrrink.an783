//
//  MapView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 10.09.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine
import Alamofire
import Firebase
import GeoFire
import GoogleMaps
import GooglePlaces

import SwiftUIMapView
import Contacts

struct MapView : UIViewRepresentable {

    var lastLocation = CLLocation(latitude: 59.939095, longitude: 30.315868).coordinate
    
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool

    let map = MKMapView()
    
    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(parent1: self)
    }
    func getBase(number: Double) -> Double {
        return round(number * 1000)/1000
    }
    
    
    func randomCoordinate() -> Double {
        return Double(arc4random_uniform(140)) * 0.00002
    }
   

     func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
    
        manager.delegate = context.coordinator
        let center = CLLocation(latitude: 59.939095, longitude: 30.315868).coordinate
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 2000, longitudinalMeters: 2000)
        map.region = region
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        
        map.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        map.register(CustomAnnotationView.self,
                                forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        map.showsUserLocation = true
        
//
//        let databaseReference = Database.database().reference()
//        databaseReference.child("objects").observe(.value)
//                             { (objects) in
//                                guard let geoDict = objects.value as? [[String: AnyObject]] else { print("(")
//                                    return }
//                                for i in geoDict {
//
//
//                                  //  print(geoDict )
//
//
//                                    let geoRef = GeoFire(firebaseRef: databaseReference.child("geo"))
//                                    geoRef.getLocationForKey("geo_id_\(i["id"] as? Int ?? 0)") { (loc, err) in
//
//
//
//                                        guard var location = loc else { return }
//                                        let anno = MKPointAnnotation()
//                                        anno.title = i["complex"] as? String ?? ""
//                                        anno.subtitle = "\(i["developer"] as? String ?? "") | \(i["address"] as? String ?? "") | \(i["deadline"] as? String ?? "")"
//
//
//
//                                        location = CLLocation(latitude: self.getBase(number: location.coordinate.latitude - 0.0) , longitude: self.getBase(number: location.coordinate.longitude - 0.0))
//
//                                        anno.coordinate = location.coordinate
//
//
//
//
//
//
//
//
//                                        DispatchQueue.main.async {
//                                            self.map.addAnnotation(anno)
//
//                                                                                                              }
//
//                                    }
//        }
//        }








        return map
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    }
    
    class Coordinator : NSObject,CLLocationManagerDelegate{
        
         var isFirst = true
        
        var parent : MapView
        
         var annotationView =  MKPinAnnotationView()
        
        init(parent1 : MapView) {
            
            parent = parent1
        }
        
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            if status == .denied{
                
                parent.alert.toggle()
                
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let location = locations.last
           
         
                if self.isFirst {
                    let region = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                                   self.parent.map.region = region
                    self.isFirst.toggle()
                }
        }
    }
   
    
    /// The map view asks `mapView(_:viewFor:)` for an appropiate annotation view for a specific annotation.
    /// - Tag: CreateAnnotationViews
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
      if let annotation = annotation as? CustomAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
        } else if let annotation = annotation as? MKClusterAnnotation {
            
        annotation.subtitle = nil
        }
        
        return annotationView
    }
        
        private func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
            return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotation.self), for: annotation)
        }
    
    private func setupClusterAnnotationView(for annotation: MKClusterAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        
    
               return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
           }

}
//                       // get geo of objects?
//
//
//                              let databaseReference = Database.database().reference()
//
//                                     databaseReference.child("objects").observe(.value)
//                                     { (objects) in
//                                        guard let objDict = objects.value as? [[String:AnyObject]] else { return }
//var count = 0
//
//
//
//                                        for objItem in objDict {
//
//
//
//                                                              // coordinates
//
//                                                                      let key : String = "AIzaSyAsGfs4rovz0-6EFUerfwiSA6OMTs2Ox-M"
//                                                                      let postParameters:[String: Any] = [ "address": "Россия  \(objItem["address"] as? String ?? "")" ,"key":key]
//                                                                      let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
//
//                                                                      AF.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
//
//
//                                                                          guard let value = response.value as? [String: AnyObject] else {
//                                                                              return
//                                                                          }
//
//
//                                                                          guard  let results = value["results"]  as? [[String: AnyObject]] else {
//                                                                              return
//                                                                          }
//
//
//                                                                          if results.count > 0 {
//
//                                                                          guard let coor = results[0]["geometry"] as? [String: AnyObject]  else {
//                                                                              print("(")
//                                                                              return
//                                                                          }
//
//
//                                                                          if  let location = coor["location"] as? [String: AnyObject]  {
//
//
//
//                                                                            let geoRef = GeoFire(firebaseRef: databaseReference.child("geo"))
//                                                                    count += 1
//                                                                            print(count)
//
//
//                                                                            geoRef.setLocation(CLLocation(latitude: location["lat"] as! CLLocationDegrees, longitude: location["lng"] as! CLLocationDegrees), forKey: "geo_id_\(objItem["id"] as! Int)")
//                                                                            //print("g")
//
//        //                                                                  let anno = MKPointAnnotation()
//        //                                                                  anno.title = objItem["complex"] as? String ?? ""
//        //                                                                      anno.coordinate = CLLocationCoordinate2D(latitude: location["lat"] as! CLLocationDegrees, longitude: location["lng"] as! CLLocationDegrees)
//        //
//        //                                                       DispatchQueue.main.async {
//        //
//        //                                                                    self.map.addAnnotation(anno)
//        //                                                                 }
//          //                                                                    }
//
//
//
//                                                                      }
//
//
//
//                                                      }
//
//                                                     }
//
//        }
//
//
//
//                }
//
//
//
//


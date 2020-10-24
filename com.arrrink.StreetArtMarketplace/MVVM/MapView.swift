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

import GoogleMaps
import GooglePlaces
import MapKitGoogleStyler
import PromiseKit
import SwiftUIMapView
import Contacts

struct MapView : UIViewRepresentable {

    var lastLocation = CLLocation(latitude: 59.939095, longitude: 30.315868).coordinate
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    @Binding var showObjectDetails : Bool
    
    @EnvironmentObject var getObjects : getTaFlatPlansData
    
    
    
    @Binding var complexNameArray: [MKPointAnnotation]
    
    
    let map = MKMapView()
    
    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(parent1: self)
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
       
            map.translatesAutoresizingMaskIntoConstraints = false

       
    
        map.delegate = context.coordinator
    
        // MARK: map custom style
        
        // We first need to have the path of the overlay configuration JSON
//        guard let overlayFileURLString = Bundle.main.path(forResource: UITraitCollection.current.userInterfaceStyle == .dark ? "darkoverlay" : "overlay", ofType: "json") else {
//                print("not f")
//                       return map
//               }
//               let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
//
//               // After that, you can create the tile overlay using MapKitGoogleStyler
//               guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
//                print("not build")
//                   return map
//               }
//
               // And finally add it to your MKMapView
       // map.addOverlay(tileOverlay)
        
        
          

        return map
    }
    
   
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        uiView.removeAnnotations(uiView.annotations)
        
        
       
         
           
            DispatchQueue.main.async {
                
                
               
                uiView.addAnnotations(complexNameArray)

        
        }
        
       
        
        
          
    }
    
    class Coordinator : NSObject,CLLocationManagerDelegate, MKMapViewDelegate {
        
         var isFirst = true
        
        var parent : MapView
        
         var annotationView =  MKPinAnnotationView()
        
        init(parent1 : MapView) {
            
            parent = parent1
            
           
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            guard view.annotation != nil else {
                return
            }
            guard !view.annotation!.isKind(of: MKUserLocation.self) else {
                // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
                return
            }
            
            
            if let title = view.annotation?.title! {
                self.parent.getObjects.tappedObjectComplexName = title
                
                self.parent.showObjectDetails = true
                
                
                
                if self.parent.getObjects.tappedObjectComplexName != "" {
                    let filter = self.parent.getObjects.objects.filter{$0.complexName == self.parent.getObjects.tappedObjectComplexName}
                    
                    self.parent.getObjects.tappedObject = filter[0]
                    
                    
                }
                
               
            }
            
            
        }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                
                if let tileOverlay = overlay as? MKTileOverlay {
                    return MKTileOverlayRenderer(tileOverlay: tileOverlay)
                } else {
                    return MKOverlayRenderer(overlay: overlay)
                }
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
            annotationView?.displayPriority = .required
        } else if let annotation = annotation as? MKClusterAnnotation {
            annotationView?.displayPriority = .required
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


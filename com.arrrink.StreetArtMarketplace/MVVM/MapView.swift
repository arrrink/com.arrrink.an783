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




struct MapView : UIViewRepresentable {

    var lastLocation = CLLocation(latitude: 59.939095, longitude: 30.315868).coordinate
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    @Binding var showObjectDetails : Bool
    
    @EnvironmentObject var getObjects : getTaFlatPlansData
  
    @Binding var complexNameArray: [CustomAnnotation]
    
    @Binding var tappedComplexName: CustomAnnotation

    let map = MKMapView()
    
    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(parent1: self)
    }
   
  
   
     func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        manager.delegate = context.coordinator
        let center = CLLocation(latitude: 59.939095, longitude: 30.315868).coordinate
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 3000, longitudinalMeters: 3000)
       
        map.region = region
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        
        map.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        map.register(CustomAnnotationView.self,
                               forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        map.showsUserLocation = true
       
            map.translatesAutoresizingMaskIntoConstraints = false

        map.userLocation.title = ""
    
        map.delegate = context.coordinator
    
        DispatchQueue.main.async {
            
            
           
            map.addAnnotations(complexNameArray)

    
    }
          

        return map
    }
    
   
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        if tappedComplexName.title != nil && getObjects.needSetRegion {
            
            uiView.region = MKCoordinateRegion(center: tappedComplexName.coordinate, span: uiView.region.span )
            
            getObjects.needSetRegion.toggle()
            
            
            
        }
        if getObjects.showCurrentLocation {
           
            guard manager.location != nil else {
                getObjects.showCurrentLocation.toggle()
                return
            }
            
            let region = MKCoordinateRegion(center: manager.location!.coordinate, span: uiView.region.span)
            
            uiView.setRegion(region, animated: false)
            getObjects.showCurrentLocation.toggle()
        }
        if getObjects.needUpdateMap {
        uiView.removeAnnotations(uiView.annotations)
        
            DispatchQueue.main.async {
                
                
               
                uiView.addAnnotations(complexNameArray)

        
        }
            getObjects.needUpdateMap.toggle()
        }
        
        
          
    }
    
    class Coordinator : NSObject,CLLocationManagerDelegate, MKMapViewDelegate {
        
         var isFirst = true
        
        var parent : MapView
        
         var annotationView =  MKPinAnnotationView()
        
        init(parent1 : MapView) {
            
            parent = parent1
            
            
            
            // MARK: map custom style
            
//           //  We first need to have the path of the overlay configuration JSON
//            guard let overlayFileURLString = Bundle.main.path(forResource: UITraitCollection.current.userInterfaceStyle == .dark ? "darkoverlay" : "overlay", ofType: "json") else {
//                    print("not f")
//                           return
//                   }
//                   let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
//
//                   // After that, you can create the tile overlay using MapKitGoogleStyler
//                   guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
//                    print("not build")
//                       return
//                   }
//
//    //                And finally add it to your MKMapView
//            parent.map.addOverlay(tileOverlay)
//
//
           
     
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            guard view.annotation != nil else {
                return
            }
            guard !view.annotation!.isKind(of: MKUserLocation.self)

            else {
               
                return
            }
            guard !view.annotation!.isKind(of: MKClusterAnnotation.self)
            else {
                
                return
            }
            guard !view.annotation!.isKind(of: MKClusterAnnotation.self)
            else {
                
                return
            }
            
            if let title = view.annotation?.title! {
                self.parent.getObjects.tappedObjectComplexName = title
                
                if view.annotation?.coordinate != nil {
                    let center = view.annotation?.coordinate

                    mapView.setRegion(MKCoordinateRegion(center: center!, span: self.parent.map.region.span ), animated: true)
                }
                self.parent.showObjectDetails = true
                
                
                
                if self.parent.getObjects.tappedObjectComplexName != "" {
                    let filter = self.parent.getObjects.objects.filter{$0.complexName == self.parent.getObjects.tappedObjectComplexName}
                    
                    self.parent.getObjects.tappedObject = filter[0]
                    
                    
                }
                
               
            }
            
            self.parent.map.deselectAnnotation(view.annotation, animated: true)
            
            
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
            
            let location = locations.last?.coordinate ?? self.parent.lastLocation
           
         
                if self.isFirst {
                    
                    if location.latitude > 59.117790 && location.longitude > 28.088136
                        && location.longitude < 35.937759 && location.latitude < 61.124369 {
                    
                    let region = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
                                   self.parent.map.region = region
                    } else {
                       let region = MKCoordinateRegion(center: self.parent.lastLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
                                       self.parent.map.region = region
                    }
                    
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
         //   annotationView?.displayPriority = .required
      
        } else if let annotation = annotation as? MKClusterAnnotation {
            annotationView?.displayPriority = .required
           
           
                
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


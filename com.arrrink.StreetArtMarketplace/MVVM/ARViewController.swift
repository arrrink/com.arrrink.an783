//
//  ARViewController.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 23.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//
import UIKit

import Foundation

import SwiftUI

import CTPanoramaView
import Combine



// ar
class SendRoomTypeToVRView {
    static var r = ""
    
    let kitchen = PassthroughSubject<String, Never>()
    
    

}

final class PinchViewController: UIViewController {
   // var data : I
    //var index = 1
    
   
   
   // @IBOutlet weak var vr: CTPanoramaView!
    
   // @IBOutlet weak var compassView: CTPieSliceView!
       

        override func viewDidLoad() {
            super.viewDidLoad()
            view.clipsToBounds = true
//            vr.controlMethod = .motion
//            vr.panoramaType = .spherical
           // NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
            
            SendRoomTypeToVRView().kitchen.send("kitchen")
            print(SendRoomTypeToVRView.r, "roomtypeUICOntr")


           // loadSphericalImage()
        }
    
    
}


extension PinchViewController: UIViewControllerRepresentable {
    
        
    public func makeUIViewController(context: UIViewControllerRepresentableContext<PinchViewController>) -> PinchViewController {
        // Get a ref to a view controller using its Interface Builder Storyboard ID
        let storyboard = UIStoryboard(name: "main", bundle: nil)  // Get ref to the storyboard
        return storyboard.instantiateViewController(withIdentifier: "pinch") as! PinchViewController
    }
    
    // Required by the protocol but not needed in this demo
    func updateUIViewController(
        _ uiViewController: PinchViewController,
        context: UIViewControllerRepresentableContext<PinchViewController>) { }
    
}
    
final class ARViewController: UIViewController {
   // var data : I
    var index = 1
    
   
   
    @IBOutlet weak var vr: CTPanoramaView!
    
    @IBOutlet weak var compassView: CTPieSliceView!
       

        override func viewDidLoad() {
            super.viewDidLoad()
            view.clipsToBounds = true
            
            vr.controlMethod = .motion
            vr.panoramaType = .spherical
            NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
            
            SendRoomTypeToVRView().kitchen.send("kitchen")
            print(SendRoomTypeToVRView.r, "roomtypeUICOntr")


            loadSphericalImage()
        }
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        if let string = notification.userInfo?["current"] as? String {
            if UIImage(named: string) != nil {
                 
                
                    if vr != nil {
                        
                        vr.image =  UIImage(named: string)
                    }
                                   
              }
          }
    }

        func loadSphericalImage() {
            if let myImage = UIImage(named: "0")
            {
                if vr != nil {
                    
                    vr.image =  myImage
                }
            }
            
                //UIImage(named: "repair")
           
        }

      

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .all
        }
    
    }
extension ARViewController: UIViewControllerRepresentable {
    
        
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewController>) -> ARViewController {
        // Get a ref to a view controller using its Interface Builder Storyboard ID
        let storyboard = UIStoryboard(name: "main", bundle: nil)  // Get ref to the storyboard
        return storyboard.instantiateViewController(withIdentifier: "arrr") as! ARViewController
    }
    
    // Required by the protocol but not needed in this demo
    func updateUIViewController(
        _ uiViewController: ARViewController,
        context: UIViewControllerRepresentableContext<ARViewController>) { }
    
   
}

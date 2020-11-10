//
//  CustomAnnotationView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 17.09.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import MapKit
import SwiftUI
import SDWebImageSwiftUI


/// - Tag: ClusterAnnotationView
class CustomAnnotationView: MKAnnotationView {
    
    static let ReuseID = "Anno"
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
//          guard let anno = newValue as? CustomAnnotation else {
//            return
//          }
          canShowCallout = false
            self.frame = bounds
           // let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
           // imgView.image = UIImage(named: "mappin")
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
            self.image = renderer.image { _ in
                
                UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05).setFill()
                UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 30, height: 30)).fill()
                
               // UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2).setFill()
               // UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: 24, height: 24)).fill()
                
//                UIColor.init(red: 1, green:0, blue: 0, alpha: 0.3).setFill()
//                UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: 20, height: 20)).fill()
                
                UIColor.init(red: 1, green: 1, blue: 1, alpha: 1).setFill()
                UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: 24, height: 24)).fill()
                
                UIColor.init(red: 1, green: 0, blue: 0, alpha: 1).setFill()
                UIBezierPath(ovalIn: CGRect(x: 6, y: 6, width: 18, height: 18)).fill()
                
                
                

               
               
            }
        }
      }

    
}

class ClusterView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
                let count = cluster.memberAnnotations.count
canShowCallout = false
            
            
                image = renderer.image { _ in
                    
                    UIColor.init(red: 1, green: 0, blue: 0, alpha: 1).setFill()
                    UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 30, height: 30)).fill()

                   
                    let piePath = UIBezierPath()
                  
                    piePath.addLine(to: CGPoint(x: 15, y: 15))
                    piePath.close()
                    piePath.fill()

                  
                    let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                                       NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
                    let text = "\(count)"
                    let size = text.size(withAttributes: attributes)
                    let rect = CGRect(x: 15 - size.width / 2, y: 15 - size.height / 2, width: size.width, height: size.height)
                    text.draw(in: rect, withAttributes: attributes)
                }
            }
        }
    }

}

class CustomAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var imageName: String?
    
    init(coordinate: CLLocationCoordinate2D, imageName: String, title : String) {
        self.coordinate = coordinate
        self.imageName = imageName
        self.title = title
        super.init()
    }
}


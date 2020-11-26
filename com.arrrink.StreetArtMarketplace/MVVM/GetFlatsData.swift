//
//  GetFlatsData.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 08.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FirebaseStorage
import RealmSwift
import Firebase
import PromiseKit

import MapKit


class getTaFlatPlansData: ObservableObject {
    var  query : Query

    @Published var data = [taFlatPlans]()
  //  @Published var dataWP = [Flat]()
  //  @Published var dataFilter = [taFlatPlans]()
    @Published var showCurrentLocation = false
    @Published var annoData = [CustomAnnotation]()
    
   // @Published var annoDataFilter = [CustomAnnotation]()
    
    @Published var tappedComplexName = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), imageName: "", title: "")
    
    @Published var objects = [taObjects]()
    
    @Published var needUpdateMap = false
    
    @Published var needSetRegion = false
    
    @Published var tappedObject = taObjects(id: "", address: "", complexName: "", deadline: "", developer: "", geo: GeoPoint(latitude: 0.0, longitude: 0.0), img: "", type: "", underground: "", timeToUnderground: "", typeToUnderground: "")
    @Published var tappedObjectComplexName = ""
    @Published var startKey = [QueryDocumentSnapshot?]()
    
    
    
    
    @Published var note = ""
    @Published var foundCount = 0
    

    @Published var currentImg = ""
    
    var ifDetailObj = false
    
   convenience init(query: Query, ifDetailObj : Bool) {
    self.init(query: query)
        self.query = query
        self.ifDetailObj = ifDetailObj

        getPromiseFlatTotal().done { (data) in
            
              if data["foundCount"] as? Int ?? 0 == 0  {
                  self.note = "Не найдено"


              } else {
                      self.note = "\(self.foundCount)"
              }
            
           
                
                self.getPromiseFlat()
                    .done { (data) in

                        self.data = data
                 

            }.catch { (er) in
                print(er)
            }
            
            
    }.catch { (er) in
        print(er)
    }
        
        
        
        
      
}
    init(query: Query) {
        
        self.query = query

        getPromiseFlatTotal().done { (data) in
            
              if data["foundCount"] as? Int ?? 0 == 0  {
                  self.note = "Не найдено"


              } else {
                      self.note = "\(self.foundCount)"
              }
            
            self.getPromiseAnno(complexNameArray: data["anno"] as? [String] ?? [String]()).done { (annoAndObjData) in

                self.annoData = annoAndObjData["annotations"] as! [CustomAnnotation]

               // self.annoDataFilter = annoAndObjData["annotations"] as! [CustomAnnotation]

                self.objects = annoAndObjData["objects"] as! [taObjects]
                self.needUpdateMap = true
              //  print(self.annoDataFilter)
                
                
                
                
                self.getPromiseFlat()
                    .done { (data) in

                        self.data = data
                     
                        
                        
                        
                        
                    }.catch { (er) in
                        print(er)
                    }

            }.catch { (er) in
                print(er)
            }
            
            
    }.catch { (er) in
        print(er)
    }
        
        
        
        
      
}
    

    
    
    func randomCoordinate() -> Double {
    return Double(arc4random_uniform(140)) * 0.0000003
            }
    func getPromiseAnno(complexNameArray : [String]) -> Promise<Dictionary<String,Any>> {
        return Promise {seal in
            
            var array = [CustomAnnotation]()
            var objects = [taObjects]()
            // geo
            
            let ref = Firebase.Firestore.firestore().collection("objects")
            
            ref.addSnapshotListener { (snap, err) in
                
                     if err != nil{
                         
                         print((err?.localizedDescription)!)
                         return
                     }
                
               
                guard !complexNameArray.isEmpty else {
                    seal.fulfill(["annotations" : array, "objects" : objects])
                    return
                }
                for j in complexNameArray {
                   
                    
                    guard  snap != nil else {
                        
                        return
                    }
                    
                  let find = snap!.documents.filter{
                    $0.get("complexName") as? String ?? "" == j
                    }
                    
                    guard find.count == 1 else {
                        seal.fulfill(["annotations" : array, "objects" : objects])
                        return
                    }
                  
                       
                   
                    
                    
                        
                        
                        
                    if let coords = find[0].get("geo"),
                       let address = find[0].get("address") as? String ?? "",
                       let complexName = find[0].get("complexName") as? String ?? "",
                       let deadline = find[0].get("deadline") as? String ?? "",
                       let developer = find[0].get("developer") as? String ?? "",
                       let id = find[0].get("id") as? Int ?? 0,
                       let img = find[0].get("img") as? String ?? "",
                       let timeToUnderground = find[0].get("timeToUnderground") as? String ?? "",
                       let type = find[0].get("type") as? String ?? "",
                       let typeToUnderground = find[0].get("typeToUnderground") as? String ?? "",
                       let underground = find[0].get("underground") as? String ?? ""
                       {
                                        let point = coords as! GeoPoint
                                        let lat = point.latitude
                                        let lon = point.longitude
                                        
                        let object = taObjects(id: String(id), address: address, complexName: complexName, deadline: deadline, developer: developer, geo: point, img: img, type: type, underground: underground, timeToUnderground: timeToUnderground, typeToUnderground: typeToUnderground)
                        
                                    
                       
                        
                        //let geo = i.document.get("geo") as! GeoPoint
                        let location = CLLocation(latitude: lat - self.randomCoordinate(), longitude: lon - self.randomCoordinate())
                       
                        let anno = CustomAnnotation(coordinate: location.coordinate, imageName: img, title: j)
                        
                        
                        
                        
                      
                        DispatchQueue.main.async {
                            objects.append(object)
                            array.append(anno)
                            if array.count == complexNameArray.count && objects.count == complexNameArray.count{
                                
                                
                                seal.fulfill(["annotations" : array, "objects" : objects])
                            }
    }
                     }
                    
                    
                    
                    
                    
        
        }
        
    }
        }
    }
    
   
    func parse(_ i: DocumentChange) -> taFlatPlans {
        let id = i.document.get("id") as? Int ?? 0
      let img = i.document.get("img") as? String ?? ""
          let price = i.document.get("price") as? Int ?? 0
          let room = i.document.get("room") as? String ?? ""
          let type = i.document.get("type") as? String ?? ""
         
          let complexName = i.document.get("complexName") as? String ?? ""
          let deadline = i.document.get("deadline") as? String ?? ""
          
          let floor = i.document.get("floor") as? Int ?? 0
          let developer = i.document.get("developer") as? String ?? ""
          
          let district = i.document.get("district") as? String ?? ""
          
        let totalS =  i.document.get("totalS") as? Double ??  Double(i.document.get("totalS") as? Int ?? 0)
            
        
        
        let kitchenS =  i.document.get("kitchenS") as? Double ??  Double(i.document.get("kitchenS") as? Int ?? 0)

        let repair = i.document.get("repair") as? String ?? ""
          let roomType = i.document.get("roomType") as? String ?? ""
          let underground = i.document.get("underground") as? String ?? ""
        
        let cession = i.document.get("cession") as? String ?? ""
        
        let section = i.document.get("section") as? String ?? ""
        
        let flatNumber = i.document.get("flatNumber") as? String ?? ""
        
        let toUnderground = i.document.get("toUnderground") as? String ?? ""
  
        return taFlatPlans(id: "\(id)", img: img, complexName: complexName, price: String(price), room: room, deadline: deadline, type: type, floor: String(floor), developer: developer, district: district , totalS: String(totalS), kitchenS: String(kitchenS), repair: repair, roomType: roomType, underground: underground, cession : cession, section: section, flatNumber : flatNumber, toUnderground: toUnderground)
          
    }
    func getPromiseFlatTotal() -> Promise<Dictionary<String, Any>> {
        return Promise {seal in
            
            var array = [String]()
            
       query
        
       .addSnapshotListener { (snap, err) in
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
        for i in snap!.documents{
            
            let complexName = i.data()["complexName"] as? String ?? ""
            
            array.append(complexName)
            
        }

        array = Array(Set(array))
        self.foundCount = snap?.documentChanges.count ?? 0
        print("Found: ", snap!.documentChanges.count, " flats")
        
        
        seal.fulfill(["foundCount" : self.foundCount, "anno" : array])
       }
        }
    }
    func getPromiseFlat() -> Promise<Array<taFlatPlans>> {
        return Promise {seal in
        
 
        var data1 = [taFlatPlans]()
            
    
            var q = query
                if startKey.count != 0 {
                    q = q.start(afterDocument: startKey[0]!)
                    
                }
            q.limit(to: 10).addSnapshotListener { (snapp, err) in
                         if err != nil{
                             print((err?.localizedDescription)!)
                             return
                         }
                     
                guard let snap = snapp else {
                    
                    return
                }
                guard snap.documents.count != 0 else {
                    print("The collection is empty.")
                    seal.fulfill(data1)
                    return
                }
                  
                guard let last = snap.documents.last else {
                    print("emty")
                    return
                }
                  
                      
                self.startKey = [last]
                    
            
                        for i in snap.documentChanges{
                            
                          
                                    DispatchQueue.main.async {
                                        data1.append(self.parse(i))
                                        
                                       // if self.limit <= snap!.documentChanges.count{
                                            
                                            if data1.count == snap.documentChanges.count {
                                                seal.fulfill(data1)
                                            }
       
                                        }
                        }
                    
                   }
                        
        
            
    }
}
}



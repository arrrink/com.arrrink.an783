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
    @Published var dataFilter = [taFlatPlans]()
    @Published var showCurrentLocation = false
    @Published var annoData = [CustomAnnotation]()
    
    @Published var annoDataFilter = [CustomAnnotation]()
    
    @Published var tappedComplexName = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), imageName: "", title: "")
    
    @Published var objects = [taObjects]()
    
    @Published var needUpdateMap = false
    
    @Published var needSetRegion = false
    
    @Published var tappedObject = taObjects(id: "", address: "", complexName: "", deadline: "", developer: "", geo: GeoPoint(latitude: 0.0, longitude: 0.0), img: "", type: "", underground: "", timeToUnderground: "", typeToUnderground: "")
    @Published var tappedObjectComplexName = ""
    @Published var startKey = [QueryDocumentSnapshot?]()
    
    @Published var limit = 80
    
    
    
    @Published var note = ""
    @Published var foundCount = 0
    
    @Published var filterFlatsOndetailView = [[taFlatPlans]]()
    
    init(query: Query) {
        
        self.query = query
        
        
       // self.maxPrice = maxPrice
        
       
        getPromiseFlat(query: query)
                .done { (data) in
                    
                    self.data = data["limitFlats"] as! [taFlatPlans]
                    self.dataFilter = self.data
                    self.note = "\(self.foundCount)"
                   
                    if self.dataFilter.count == 0  {
                        self.note = "Не найдено"
                        
                        
                    } else {
                            self.note = "\(self.dataFilter.count)"
                    }
                    
                    
                    
                    self.getPromiseAnno(complexNameArray: data["anno"] as! [String]).done { (annoAndObjData) in
                        
                        self.annoData = annoAndObjData["annotations"] as! [CustomAnnotation]
                        
                        self.annoDataFilter = annoAndObjData["annotations"] as! [CustomAnnotation]
                        
                        self.objects = annoAndObjData["objects"] as! [taObjects]
                        self.needUpdateMap = true
                        print(self.annoDataFilter)
                        
                    }.catch { (er) in
                        print(er)
                    }
                }.catch { (er) in
                    print(er)
                }
      
}
    

    
    
    func randomCoordinate() -> Double {
    return Double(arc4random_uniform(140)) * 0.00003
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
                
               
               
                
                for j in complexNameArray {
                   
                    
                    guard  snap != nil else {
                        return
                    }
                    
                  let find = snap!.documents.filter{
                    $0.get("complexName") as? String ?? "" == j
                    }
                    
                    guard find.count == 1 else {
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
                        let location = CLLocation(latitude: lat + self.randomCoordinate(), longitude: lon + self.randomCoordinate())
                       
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
          
        let totalS = i.document.get("totalS") as? Double ?? 0.0
          
        let kitchenS = i.document.get("kitchenS") as? Double ?? 0.0
          let repair = i.document.get("repair") as? String ?? ""
          let roomType = i.document.get("roomType") as? String ?? ""
          let underground = i.document.get("underground") as? String ?? ""

          
          
          
          
  
         return taFlatPlans(id: "\(id)", img: img, complexName: complexName, price: String(price), room: room, deadline: deadline, type: type, floor: String(floor), developer: developer, district: district , totalS: String(totalS), kitchenS: String(kitchenS), repair: repair, roomType: roomType, underground: underground)
          
    }
    func getPromiseFlat(query: Query) -> Promise<Dictionary<String,Any>> {
        return Promise {seal in
        
//        }
//      return Promise<Array<taFlatPlans>>() { seal in
            
            
        
        var data1 = [taFlatPlans]()
            
            
            var array = [String]()
            
            
//
//                var string = String(Int((maxPrice / 100000).rounded() * 100000)).reversed
//
//                string = string.separate(every: 3, with: " ")
//
//                string = string.reversed
           // var query = Firebase.Firestore.firestore().collection("taflatplans")
                
//            if maxPrice != 0.0 {
//                query = query.whereField("price", isLessThanOrEqualTo: Int((maxPrice / 100000).rounded() * 100000)).order(by: "price", descending: true) as! CollectionReference
//            } else {
//                query = query.order(by: "price", descending: true) as! CollectionReference
//            }
//
              //  var query = Firebase.Firestore.firestore().collection("taflatplans").whereField("totalS", isLessThanOrEqualTo: 40).order(by: "totalS", descending: true)
                
                
//                query.addSnapshotListener { (snapFoundCount, err) in
//                    if err != nil{
//
//                        print((err?.localizedDescription)!)
//                        return
//                    }
//                    self.foundCount = snapFoundCount?.documentChanges.count ?? 0
//                    print("Found: ", snapFoundCount!.documentChanges.count, " flats")
//                }
//
//                if startKey.count != 0 {
//                    query = query.start(afterDocument: startKey[0]!)
//                }
                query
                    //.limit(to: limit)
                   .addSnapshotListener { (snap, err) in
                        if err != nil{
                            
                            print((err?.localizedDescription)!)
                            return
                        }
                    
                    self.foundCount = snap?.documentChanges.count ?? 0
                    print("Found: ", snap!.documentChanges.count, " flats")
                    
                    if (snap?.documents.last) != nil {
                        
                        if self.limit <= snap!.documentChanges.count{
                            
                            self.startKey = [snap?.documents[self.limit + 1]]
                               
                        }
//                        else {
//                            if data1.count == snap!.documentChanges.count {
//                                self.startKey = [snap?.documents[snap!.documentChanges.count]]
//                            }
//                        }
                        
                        
                    } else {
                        print("The collection is empty.")
                        seal.fulfill(["anno": array, "limitFlats" : data1])
                    }
                       
                    
                    for i in snap!.documentChanges{
                        
                        let complexName = i.document.get("complexName") as? String ?? ""
                        
                        array.append(complexName)
                        
                    }
                    
                    
                    array = Array(Set(array))
                    
                    
                    
                    
                        for i in snap!.documentChanges{
                            
                          
                                    DispatchQueue.main.async {
                                        data1.append(self.parse(i))
                                        
                                       // if self.limit <= snap!.documentChanges.count{
                                            
                                            if data1.count == snap!.documentChanges.count {
                                                seal.fulfill(["anno": array, "limitFlats" : data1])
                                            }
                                               
//                                        } else {
//                                            if data1.count == snap!.documentChanges.count {
//                                                seal.fulfill(["anno": array, "limitFlats" : data1])
//                                            }
//                                        }
                                        }
                        }
                    
                   }
                        
                        
                
                  //  }
//            } else {
//
//                // total search if got maxPrice == 0.0
//
//
//                var query = Firebase.Firestore.firestore().collection("taflatplans").order(by: "price", descending: true)
//
//                query.addSnapshotListener { (snapFoundCount, err) in
//                    if err != nil{
//
//                        print((err?.localizedDescription)!)
//                        return
//                    }
//                    self.foundCount = snapFoundCount?.documentChanges.count ?? 0
//                    print("Found: ", snapFoundCount!.documentChanges.count, " flats")
//                }
//
//                if startKey.count != 0 {
//                    query = query.start(afterDocument: startKey[0]!)
//                }
//                query
//                    //.limit(to: limit)
//                   .addSnapshotListener { (snap, err) in
//                        if err != nil{
//
//                            print((err?.localizedDescription)!)
//                            return
//                        }
//
//                    if (snap?.documents.last) != nil {
//
//                        if self.limit <= snap!.documentChanges.count{
//
//                            self.startKey = [snap?.documents[self.limit + 1]]
//
//                        }
////                        else {
////                            if data1.count == snap!.documentChanges.count {
////                                self.startKey = [snap?.documents[snap!.documentChanges.count]]
////                            }
////                        }
//
//
//                    } else {
//                        print("The collection is empty.")
//                        seal.fulfill(["anno": array, "limitFlats" : data1])
//                    }
//
//
//                    for i in snap!.documentChanges{
//
//                        let complexName = i.document.get("complexName") as? String ?? ""
//
//                        array.append(complexName)
//
//                    }
//
//                    array = Array(Set(array))
//
//                        for i in snap!.documentChanges{
//
//
//                                    DispatchQueue.main.async {
//                                        data1.append(self.parse(i))
//
//                                        if self.limit <= snap!.documentChanges.count{
//
//                                            if data1.count == self.limit {
//                                                seal.fulfill(["anno": array, "limitFlats" : data1])
//                                            }
//
//                                        } else {
//                                            if data1.count == snap!.documentChanges.count {
//                                                seal.fulfill(["anno": array, "limitFlats" : data1])
//                                            }
//                                        }
//                                        }
//                    }
//
//
//
//                    }
//            }
                
             
                
               
//
//            Firebase.Database.database().reference().child("taflatplans")
//                .observe(.value, with: { (snap) in
//
//                                        guard let children = snap.children.allObjects as? [DataSnapshot] else {
//
//                                        print("((((((")
//                                        return
//                                      }
//
//                                        guard children.count != 0 else {
//                                            print("cant 0")
//                                            return
//                                        }
//
//                                        for j in children {
//
//                                            var desc = [String: Any]()
//
//                                            desc = ["id" : j.childSnapshot(forPath: "id").value as? Int ?? 0,
//                                                    "img" : j.childSnapshot(forPath: "img").value as? String ?? "",
//                                                    "price" : j.childSnapshot(forPath: "price").value as? String ?? "",
//                                                    "room" : j.childSnapshot(forPath: "room").value as? String ?? "",
//                                                    "type" :  j.childSnapshot(forPath: "type").value as? String ?? "",
//                                                    "name" : j.childSnapshot(forPath: "name").value as? String ?? "",
//                                                    "deadline" : j.childSnapshot(forPath: "deadline").value as? String ?? ""
//
//                                            ]
//
//                                            DispatchQueue.main.async {
//
//                                                Firebase.Firestore.firestore().collection("taflatplans").document("\(j.childSnapshot(forPath: "id").value as? Int ?? 0)").setData(desc)
//
//
//                                            }
//                                            print(desc)
//                                        }
//
//            // let count = 5
//
//            let query2 = Database.database().reference().child("taflatplans")
//               // if startKey != 0 {
////            guard query2.queryStarting(atValue: startKey) is DatabaseReference else {
////                print("((")
////                return
////            }
//        //}
//
////            if maxPrice == 0.0 {
////            query2.queryOrdered(byChild: "id").queryStarting(atValue: startKey).queryLimited(toFirst: UInt(limit + 1)).observe(.value) { (snapshot) in
////
////            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
////            print("((((((")
////            return
////          }
////
////
////
////                                   for i in children {
////
////                                           let flatId = i.childSnapshot(forPath: "id").value ?? 0
////
////                                           let flatImg = i.childSnapshot(forPath: "img").value ?? ""
////                                           let flatComplexName = i.childSnapshot(forPath: "name").value ?? ""
////                                           let flatPrice = i.childSnapshot(forPath: "price").value ?? ""
////                                           let flatRoom = i.childSnapshot(forPath: "room").value ?? ""
////                                           let flatDeadline = i.childSnapshot(forPath: "deadline").value ?? ""
////
////                                           let flatType = i.childSnapshot(forPath: "type").value ?? ""
////
////                                    let flatTypeParse = flatType as! String == "Новостройка</li>" ? "Новостройки" : "Апартаменты"
////
////
////                                    let item = taFlatPlans(id: "\(flatId as! Int)",
////                                                                   img: flatImg as! String,
////                                                                   complexName: flatComplexName as! String,
////                                                                   price: flatPrice as! String,
////                                                                   room: flatRoom as! String,
////                                                                   deadline: flatDeadline as! String,
////                                                                   type: flatTypeParse)
////
////                                    //createItem
////
////                                    DispatchQueue.main.async {
////                                        data1.append(item)
////
////                                         if data1.count == limit {
////
////                                            seal.fulfill(data1)
////                                         }
////                                    }
////
////        }
////
////      }
////            } else {
//                var string = String(Int(maxPrice)).reversed
//
//                string = string.separate(every: 3, with: " ")
//
//                string = string.reversed
//
//                print("\(string) руб.")
//
//
//                query2.queryOrdered(byChild: "price").queryEnding(atValue: "\(string) руб.").queryLimited(toLast: 8).observe(.value) { (snapshot) in
//
//                    guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
//                    print("((((((")
//                    return
//                  }
//
//
//
//                                           for i in children {
//
//                                                   let flatId = i.childSnapshot(forPath: "id").value ?? 0
//
//                                                   let flatImg = i.childSnapshot(forPath: "img").value ?? ""
//                                                   let flatComplexName = i.childSnapshot(forPath: "name").value ?? ""
//                                                   let flatPrice = i.childSnapshot(forPath: "price").value ?? ""
//                                                   let flatRoom = i.childSnapshot(forPath: "room").value ?? ""
//                                                   let flatDeadline = i.childSnapshot(forPath: "deadline").value ?? ""
//
//                                                   let flatType = i.childSnapshot(forPath: "type").value ?? ""
//
//                                            let flatTypeParse = flatType as! String == "Новостройка</li>" ? "Новостройки" : "Апартаменты"
//
//
//                                            let item = taFlatPlans(id: "\(flatId as! Int)",
//                                                                           img: flatImg as! String,
//                                                                           complexName: flatComplexName as! String,
//                                                                           price: flatPrice as! String,
//                                                                           room: flatRoom as! String,
//                                                                           deadline: flatDeadline as! String,
//                                                                           type: flatTypeParse)
//
//                                            //createItem
//
//                                            DispatchQueue.main.async {
//                                                data1.append(item)
//
//                                                 if data1.count == 8 {
//
//                                                    seal.fulfill(data1)
//                                                 }
//                                            }
//
//                }
          
           //   }
            
    }
}
}



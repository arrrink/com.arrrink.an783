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


import MapKit

enum Screens {
    case first, home, ipoteka, apart
}
class getTaFlatPlansData: ObservableObject {
    var  queryWHERE : String

    var  db :  BigQueryClient<BigQuerySchema>
  
    @Published var currentScreen : Screens = .first
    
    @Published var data = [taFlatPlans]()

      @Published var dataTappedObj = [taFlatPlans]()
    @Published var showCurrentLocation = false
    @Published var annoData = [CustomAnnotation]()
    
   // @Published var annoDataFilter = [CustomAnnotation]()
    
    @Published var tappedComplexName = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), imageName: "", title: "")
    
    @Published var objects = [taObjects]()
    
    @Published var needUpdateMap = false
    
    @Published var needSetRegion = false
    
    @Published var tappedObject = taObjects(id: "", address: "", complexName: "", deadline: "", developer: "", geo: GeoPoint(latitude: 0.0, longitude: 0.0), img: "", type: "", underground: "", toUnderground: "", cession: "")
    @Published var tappedObjectComplexName = ""
    
    
    @Published var limit = 10
    
    @Published var offset = 0
    
    @Published var limitTappedObj = 10
    
    @Published var offsetTappedObj = 0
    
    
    
    
    @Published var note = ""
    
    @Published var noteTappedObj = ""
    

    @Published var currentImg = ""
    
    
    init(queryWHERE: String) {
        
        self.queryWHERE = queryWHERE
        self.db = BigQueryClient(
            authenticationToken: "",
            projectID: "realestateagency78spb",
            datasetID: "data",
            tableName: "taflatplans"
        )

        
        
        
}
    
    func initObserve() {
        
        
        let provider = BigQueryAuthProvider()
        try! provider.getAuthenticationToken { r in
           // let response: AuthResponse?


//            guard let r = response else {
//                        print("Unexpected empty response")
//                return
//                    }
                    switch r {
                    
                    case .token(let token):
                        
                        

                        self.db = BigQueryClient(
                            authenticationToken: token,
                            projectID: "realestateagency78spb",
                            datasetID: "data",
                            tableName: "taflatplans"
                        )
                       
                        
                        self.initBQ()
        
       
                    
                    case .error(let e):
                            print(e)
                  }

        }
       
    }
    
    func initBQ() {
        
        DispatchQueue.main.async {
            self.note = ""
            self.data.removeAll()
            self.annoData.removeAll()
            
        

        self.getBQTotal(q: "SELECT id FROM data.taflatplans " + self.queryWHERE, completionHandler: { (foundCount) in
            
            DispatchQueue.main.async {
           // print("foundCount ", foundCount)

guard foundCount != 0 else {

self.note = "Не найдено"
self.data.removeAll()

self.annoData.removeAll()
self.objects.removeAll()
self.needUpdateMap = true



return
}
self.note = "\(foundCount)"
            

          
            
            
            self.getBQUnicComplexNameArray(q: "select distinct complexName from data.taflatplans " + self.queryWHERE.replacingOccurrences(of: "order by price", with: "order by complexName"), completionHandler: { (anno) in
                
                DispatchQueue.main.async {
                self.getPromiseAnno(complexNameArray: anno, completitionHander: { (annoAndObjData) in
                    
                
                    DispatchQueue.main.async {

                self.annoData = annoAndObjData["annotations"] as! [CustomAnnotation]
                
                self.objects = annoAndObjData["objects"] as! [taObjects]
        
        
                self.needUpdateMap = true
    
    
    
    self.getBQLimitOffset(q: "SELECT * FROM data.taflatplans " + self.queryWHERE + "  limit \(self.limit) offset \(self.offset)", completitionHander: { (flats) in
        DispatchQueue.main.async {
            self.data.append(contentsOf: flats)
        }
    
    })
        
    
                    }
                    
                })
                }    })


            }


})
    }
    
    }
    func getBQTotal(q : String, completionHandler : @escaping (Int) -> Void)  {
      
             //   print("SQL query : \(q)")
                        db.query(q) { (res) in
                            
                            guard let totalFound = res.totalRows else {
                                return
                            }
                            completionHandler(Int(totalFound) ?? 0)
                            
                        }
        
       }
    
    func getBQUnicComplexNameArray(q : String, completionHandler : @escaping ([String]) -> Void)  {

                        db.query(q) { (res) in
                            guard let simpleDict = res.toComplexArrayDictionary()  else {
                                completionHandler([String]())
                                return
                            }
                            
                            completionHandler(simpleDict)
                        }
        
       }
    
    func getBQLimitOffset(q : String, completitionHander : @escaping (Array<taFlatPlans>) -> Void)   {
                        db.query(q) { (res) in
                            
                            DispatchQueue.main.async {
                            
                            guard let totalFound = res.totalRows else {
                                completitionHander([taFlatPlans]())

                                return
                            }
                            
                           
                                
                            
                            
                            self.limit = Int(totalFound) ?? 0
                            
                            
                            self.offset += self.limit 
                            
                            
                            
                            guard let simpleDict = res.toDictionary()  else {
                                completitionHander([taFlatPlans]())
                                return
                            }
                            
                                completitionHander(simpleDict)
                            }
                        }
      
        
       }
    
    func getBQLimitOffsetTappedObj(q : String, completionHandler : @escaping ([taFlatPlans]) -> Void)  {
                        db.query(q) { (res) in
                           
                            guard let totalFound = res.totalRows else {
                                completionHandler([taFlatPlans]())
                                return
                            }
                            
                           
                            DispatchQueue.main.async {
                            self.limitTappedObj = Int(totalFound) ?? 0
                            
                            
                            self.offsetTappedObj += self.limitTappedObj
                            
                            }
                            
                            guard let simpleDict = res.toDictionary()  else {
                                completionHandler([taFlatPlans]())
                                return
                            }
                                completionHandler(simpleDict)
                            
                        }
      
        
       }

    
    
    func randomCoordinate() -> Double {
    return Double(arc4random_uniform(140)) * 0.000003
            }
    func getPromiseAnno(complexNameArray : [String], completitionHander : @escaping ([String:Any]) -> Void)  {
            
            var array = [CustomAnnotation]()
            var objects = [taObjects]()
            // geo
            var totalCount = complexNameArray.count
            let ref = Firebase.Firestore.firestore().collection("objects")
            
            ref.addSnapshotListener { (snap, err) in
                
                     if err != nil{
                         
                         print((err?.localizedDescription)!)
                         return
                     }
                
               
                guard !complexNameArray.isEmpty else {
                    
                    completitionHander(["annotations" : array, "objects" : objects])
                    return
                }
                for j in complexNameArray {
                   
                    
                    guard  snap != nil else {
                        
                        return
                    }
                    
                  let find = snap!.documents.filter{
                    $0.get("complexName") as? String ?? "" == j
                    }
                    if find.count != 1 {
                    
                        
                      //  print("empty cN")
                        totalCount -= 1
                        if totalCount == 0 {

                            if array.count == totalCount && objects.count == totalCount{
                                
                                
                                completitionHander(["annotations" : array, "objects" : objects])
                            }
                        }
                    } else {
                  
                       
                   
                    
                    
                        
                        
                        
                    if let coords = find[0].get("geo"),
                       let address = find[0].get("address") as? String ,
                       let complexName = find[0].get("complexName") as? String ,
                       let deadline = find[0].get("deadline") as? String,
                       let developer = find[0].get("developer") as? String ,
                       let id = find[0].get("id") as? Int,
                       let img = find[0].get("img") as? String,
                       let cession = find[0].get("cession") as? String,
                       let type = find[0].get("type") as? String ,
                       let toUnderground = find[0].get("toUnderground") as? String,
                       let underground = find[0].get("underground") as? String
                       {
                                        let point = coords as! GeoPoint
                                        let lat = point.latitude
                                        let lon = point.longitude
                                        
                        let object = taObjects(id: String(id), address: address, complexName: complexName, deadline: deadline, developer: developer, geo: point, img: img, type: type, underground: underground, toUnderground: toUnderground, cession: cession)
                        
                                    
                       
                        
                        //let geo = i.document.get("geo") as! GeoPoint
                        let location = CLLocation(latitude: lat - self.randomCoordinate(), longitude: lon - self.randomCoordinate())
                       
                        let anno = CustomAnnotation(coordinate: location.coordinate, imageName: img, title: j)
                        
                        
                        
                        
                      
                        DispatchQueue.main.async {
                            objects.append(object)
                            array.append(anno)
                            
        
                            if array.count == totalCount && objects.count == totalCount{
                                
                                
                                completitionHander(["annotations" : array, "objects" : objects])
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

}




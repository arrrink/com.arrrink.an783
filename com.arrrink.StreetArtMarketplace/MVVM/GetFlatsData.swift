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


class getTaFlatPlansData: ObservableObject {


    @Published var data = [taFlatPlans]()
    
    @Published var dataFromTable = [taFlatTable]()
    
    
    @Published var startKey = 0
    
    @Published var limit = 1

    init(startKey: Int, limit: Int) {
        
        self.startKey = startKey
        
        self.limit = limit
    
        getPromiseFlat(startKey: self.startKey, limit: self.limit)
//            .then({ data1 -> Promise<Array<taFlatTable>> in
//                self.data.append(contentsOf: data1)
//
//                    print(self.data.count)
//                return self.loadTableflats(data1)
//
//            })
            .done({ (data2) in
                self.data.append(contentsOf: data2)
            })
            .catch { (er) in
            
            print(er)
        }
}
    func loadTableflats(_ data: [taFlatPlans]) -> Promise<Array<taFlatTable>> {
        return Promise {seal in
            
            let count = 5
            var data2 = [taFlatTable]()
            
            for i in data {
                
                
                
              //  fromTable
               
                Database.database().reference().child("taflattable").queryOrdered(byChild: "id").queryEqual(toValue: Int(i.id)).observe(.value) { (snapTable) in


                   

                   guard let childrenTable = snapTable.children.allObjects as? [DataSnapshot] else {
                   print("((((((")
                   return
                 }
                   guard childrenTable.count != 0 else {
                       print("cant 0")

                       return
                   }

                 //  childrenTable.removeFirst()

                   for j in childrenTable {
                       let flatNumber = j.childSnapshot(forPath: "flatNumber").value ?? ""
                       let flatDisrict = j.childSnapshot(forPath: "district").value ?? ""
                       let flatUnderground = j.childSnapshot(forPath: "underground").value ?? ""
                       let flatDeveloper = j.childSnapshot(forPath: "developer").value ?? ""
                       let flatSection = j.childSnapshot(forPath: "section").value ?? ""
                       let flatTotalS = j.childSnapshot(forPath: "totalS").value ?? ""
                       let flatKitchenS = j.childSnapshot(forPath: "kitchenS").value ?? 0
                       let flatRepair = j.childSnapshot(forPath: "repair").value ?? ""
                       let flatFloor = j.childSnapshot(forPath: "flor").value ?? 0




                    let item = taFlatTable(id: i.id,
                                                      flatNumber: flatNumber as! String,
                                                      district: flatDisrict as! String,
                                                      underground: flatUnderground as! String,
                                                      developer: flatDeveloper as! String,
                                                      //complex:,
                                                      section: flatSection as! String,
                                                      totalS: flatTotalS as! String,
                                                      kitchenS: "\(flatKitchenS as! Double)",
                                                      repair: flatRepair as! String,
                                                      floor: "\(flatFloor as! Int)")
                                                      //status: ""

                       //createItem

                       DispatchQueue.main.async {
                           data2.append(item)

                            if data2.count == count {

                               seal.fulfill(data2)
                            } else {
                               print("no", data2.count)
                            }

                       }



                   }

               }
                
                
                
                
            }
            
            seal.fulfill([taFlatTable]())
        }
    }
    
    func getPromiseFlat(startKey : Int, limit: Int) -> Promise<Array<taFlatPlans>> {
        return Promise {seal in
        
//        }
//      return Promise<Array<taFlatPlans>>() { seal in
            
            
        
        var data1 = [taFlatPlans]()
        
            // let count = 5
        
            let query2 = Database.database().reference().child("taflatplans").queryOrdered(byChild: "id")
                if startKey != 0 {
//            guard query2.queryStarting(atValue: startKey) is DatabaseReference else {
//                print("((")
//                return
//            }
        }
        query2.queryStarting(atValue: startKey).queryLimited(toFirst: UInt(limit + 1)).observe(.value) { (snapshot) in
            
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
            print("((((((")
            return
          }


            
                                   for i in children {

                                           let flatId = i.childSnapshot(forPath: "id").value ?? 0
                                                            
                                           let flatImg = i.childSnapshot(forPath: "img").value ?? ""
                                           let flatComplexName = i.childSnapshot(forPath: "name").value ?? ""
                                           let flatPrice = i.childSnapshot(forPath: "price").value ?? ""
                                           let flatRoom = i.childSnapshot(forPath: "room").value ?? ""
                                           let flatDeadline = i.childSnapshot(forPath: "deadline").value ?? ""

                                           let flatType = i.childSnapshot(forPath: "type").value ?? ""

                                    let flatTypeParse = flatType as! String == "Новостройка</li>" ? "Новостройки" : "Апартаменты"
                                    
                                    
                                    let item = taFlatPlans(id: "\(flatId as! Int)",
                                                                   img: flatImg as! String,
                                                                   complexName: flatComplexName as! String,
                                                                   price: flatPrice as! String,
                                                                   room: flatRoom as! String,
                                                                   deadline: flatDeadline as! String,
                                                                   type: flatTypeParse)

                                    //createItem

                                    DispatchQueue.main.async {
                                        data1.append(item)

                                         if data1.count == limit {

                                            seal.fulfill(data1)
                                         }
                                    }
              
        }
  
      }

    }
}
}


